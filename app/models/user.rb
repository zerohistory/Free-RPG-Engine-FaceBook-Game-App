class User < ActiveRecord::Base
  GENDERS = {:male => 1, :female => 2}
  
  has_one     :character, :dependent => :destroy
  belongs_to  :referrer, :class_name => "User"

  named_scope :after, Proc.new{|user|
    {
      :conditions => ["`users`.id > ?", user.is_a?(User) ? user.id : user.to_i],
      :order      => "`users`.id ASC"
    }
  }
  
  named_scope :with_email, {:conditions => "email != ''"}
  
  after_save :schedule_social_data_update, :if => :access_token_changed?  

  def show_tutorial?
    Setting.b(:user_tutorial_enabled) && self[:show_tutorial]
  end

  def customized?
    true
  end

  def touch!
    update_attribute(:updated_at, Time.now)
  end

  def admin?
    Setting.a(:user_admins).include?(facebook_id.to_s)
  end
  
  def last_visit_ip=(value)
    self[:last_visit_ip] = value.is_a?(String) ? IPAddr.new(value).to_i : value
  end
  
  def last_visit_ip
    IPAddr.new(self[:last_visit_ip], Socket::AF_INET) if self[:last_visit_ip]
  end
  
  def signup_ip=(value)
    self[:signup_ip] = value.is_a?(String) ? IPAddr.new(value).to_i : value
  end
  
  def signup_ip
    IPAddr.new(self[:signup_ip], Socket::AF_INET) if self[:signup_ip]
  end
  
  def friend_ids=(values)
    self[:friend_ids] = Array.wrap(values).join(',')
  end
  
  def friend_ids
    self[:friend_ids].blank? ? [] : self[:friend_ids].split(',').collect{|i| i.to_i }
  end
  
  def update_social_data!
    return false unless access_token_valid?
    
    client = Mogli::Client.new(access_token)
    
    facebook_user = Mogli::User.find(facebook_id, client, :first_name, :last_name, :timezone, :locale, :gender, :third_party_id, :email)
    
    %w{first_name last_name timezone locale third_party_id email}.each do |attribute|
      self.send("#{attribute}=", facebook_user.send(attribute))
    end
    
    self.gender = facebook_user.gender if facebook_user.gender
    
    self.friend_ids = facebook_user.friends(:id).collect{|f| f.id }
    
    save!
  end
  
  def gender=(value)
    if value.blank?
      self[:gender] = nil
    elsif GENDERS[value.to_sym]
      self[:gender] = GENDERS[value.to_sym]
    else
      raise ArgumentError.new("Only #{ GENDERS.keys.join(' and ') } values are allowed")
    end
  end
  
  def gender
    GENDERS.index(self[:gender])
  end
  
  def access_token_valid?
    !(access_token.blank? || access_token_expire_at.nil? || access_token_expire_at < Time.now)
  end
  
  def schedule_social_data_update
    Delayed::Job.enqueue Jobs::UserDataUpdate.new([id]) if access_token_valid?
  end
end
