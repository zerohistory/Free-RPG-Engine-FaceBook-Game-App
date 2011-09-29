class AppRequest::Base < ActiveRecord::Base
  set_table_name :app_requests
  
  belongs_to :sender, :class_name => "Character"
  
  named_scope :for, Proc.new {|character|
    {
      :conditions => {:receiver_id => character.facebook_id}
    }
  }
  named_scope :from, Proc.new{|character|
    {
      :conditions => {:sender_id => character.id}
    }
  }
  named_scope :between, Proc.new{|sender, receiver|
    {
      :conditions => {:sender_id => sender.id, :receiver_id => receiver.facebook_id}
    }
  }

  state_machine :initial => :pending do
    state :processed
    state :visited
    state :accepted
    state :ignored

    event :process do
      transition :pending => :processed
    end

    event :visit do
      transition [:pending, :processed] => :visited
    end
    
    event :accept do
      transition [:processed, :visited] => :accepted
    end
    
    event :ignore do
      transition [:pending, :processed, :visited] => :ignored
    end
    
    before_transition :on => :process do |request|
      request.processed_at = Time.now
    end

    before_transition :on => :visit do |request|
      request.visited_at = Time.now
    end
    
    before_transition :on => :accept do |request|
      request.accepted_at = Time.now
    end

    after_transition :on => :accept do |request|
      request.send(:after_accept)
    end

    after_transition :on => :ignore do |request|
      request.send(:after_ignore)
    end
  end

  serialize :data
  
  validates_presence_of :facebook_id
  
  after_create :schedule_data_update
  
  class << self
    def mogli_client
      Mogli::AppClient.create_and_authenticate_as_application(Facebooker2.app_id, Facebooker2.secret)
    end

    def schedule_deletion(*ids_or_requests)
      ids = ids_or_requests.flatten.compact.collect{|value| value.is_a?(AppRequest::Base) ? value.id : value}.uniq
      
      Delayed::Job.enqueue(Jobs::RequestDelete.new(ids)) unless ids.empty?
    end
    
    def receiver_ids
      all(:select => :receiver_id).collect{|r| r.receiver_id }
    end
    
    def check_user_requests(user)
      facebook_user = Mogli::User.find(user.facebook_id, mogli_client, :apprequests)
      
      facebook_user.apprequests.each do |facebook_request|
        request = AppRequest::Base.find_or_initialize_by_facebook_id(facebook_request.id)
        
        request.update_from_facebook_request(facebook_request) if request.pending?
      end
    end
  end
  
  def receiver
    @receiver ||= User.find_by_facebook_id(receiver_id).try(:character)
  end
  
  def update_from_facebook_request(facebook_request)
    if facebook_request.from.nil?
      ignore!
    else
      self.data = JSON.parse(facebook_request.data) if facebook_request.data
  
      becomes(request_class_from_data).tap do |request|
        # Ensure that the new type will be saved correctly
        request.type = request.class.sti_name
      
        request.sender = User.find_by_facebook_id(facebook_request.from.id).character
        request.receiver_id = facebook_request.to.id
      
        request.transaction do
          request.save!
          request.process
        end
      end
    end
  end

  def update_data!
    update_from_facebook_request(Mogli::AppRequest.find(facebook_id, self.class.mogli_client))
  end
  
  def delete_from_facebook!
    Mogli::AppRequest.new({:id => facebook_id}, self.class.mogli_client).destroy
  end

  def type_name
    self.class.name.split('::')[1].underscore
  end
  
  def acceptable?
    true
  end

  protected
  
  def request_class_from_data
    if data.nil?
      'AppRequest::Invitation'
    elsif data['type']
      "AppRequest::#{ data['type'].classify }"
    elsif data['item_id']
      'AppRequest::Gift'
    elsif data['monster_id']
      'AppRequest::MonsterInvite'
    else
      'AppRequest::Invitation'
    end.constantize
  end
  
  def after_accept
    self.class.schedule_deletion(self)
  end
  
  def after_ignore
    self.class.schedule_deletion(self)
  end
  
  def schedule_data_update
    Delayed::Job.enqueue Jobs::RequestDataUpdate.new(id)
  end
end
