class VipMoneyOperation < ActiveRecord::Base
  belongs_to :character

  named_scope :latest, :order => "id DESC"
  named_scope :by_reference_type, Proc.new{|type|
    {:conditions => ["reference_type = ?", type]}
  }
  named_scope :by_profile_ids, Proc.new{|ids|
    {
      :joins => {:character => :user},
      :conditions => ["characters.id IN (:ids) OR users.facebook_id IN (:ids)", {:ids => ids}]
    }
  }

  attr_accessible :amount, :reference

  validates_presence_of :amount
  validates_numericality_of :amount, :greater_than => 0, :only_integer => true

  def self.reference_type_options_for_select
    all(:select => "DISTINCT reference_type").collect do |r|
      [r[:reference_type].humanize, r[:reference_type]]
    end
  end

  def reference=(value)
    case value
    when ActiveRecord::Base
      self.reference_id   = value.id
      self.reference_type = value.class.sti_name
    when Array
      self.reference_type = value.first.to_s
      self.reference_id   = value.last
    else
      self.reference_type = value.to_s
    end
  end

  def reference
    klass = reference_type.constantize

    klass.find_by_id(reference_id)
  rescue NameError
    reference_type
  end
end
