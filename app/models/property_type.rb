class PropertyType < ActiveRecord::Base
  extend HasPayouts
  extend HasRequirements
  include HasVisibility

  AVAILABILITIES = [:shop, :mission, :loot]

  has_many :properties, :dependent => :destroy

  has_many :property_losses
  has_many :fights, :through => :property_losses

  has_payouts :collect
  has_requirements

  has_attached_file :image,
    :styles => {
      :icon   => "50x50>",
      :small  => "120x120>",
      :medium => "180x180>",
      :stream => "90x90#"
    },
    :removable => true

  named_scope :available_in, Proc.new{|*keys|
    valid_keys = keys.collect{|k| k.to_sym } & AVAILABILITIES # Find intersections between passed key list and available keys

    if valid_keys.any?
      valid_keys.collect!{|k| k.to_s }

      {:conditions => ["property_types.availability IN (?)", valid_keys]}
    else
      {}
    end
  }

  named_scope :available_by_level, Proc.new {|character|
    {
      :conditions => ["level <= ?", character.level],
      :order      => :basic_price
    }
  }

  state_machine :initial => :hidden do
    state :hidden
    state :visible
    state :deleted

    event :publish do
      transition :hidden => :visible
    end

    event :hide do
      transition :visible => :hidden
    end

    event :mark_deleted do
      transition(any - [:deleted] => :deleted)
    end
  end

  validates_presence_of :name, :availability, :basic_price, :income
  validates_numericality_of :basic_price, :vip_price, :income, :upgrade_limit, :allow_nil => true

  class << self
    def to_dropdown(*args)
      without_state(:deleted).all(:order => :basic_price).to_dropdown(*args)
    end

    def available_for(character)
      visible_for(character).available_by_level(character)
    end
  end

  def upgradeable?
    (upgrade_limit || Setting.i(:property_upgrade_limit)) > 1
  end

  def basic_price
    self[:basic_price].to_i
  end

  def vip_price
    self[:vip_price].to_i
  end

  def availability
    self[:availability].to_sym
  end

  def plural_name
    self[:plural_name].blank? ? name.pluralize : self[:plural_name]
  end

  def upgrade_price(level)
    upgrade_cost_increase ? basic_price + upgrade_cost_increase * level : basic_price
  end

  def requirements_satisfied?(character)
    requirements.satisfies?(character)
  end
end
