class Item < ActiveRecord::Base
  extend HasPayouts
  extend HasRequirements
  include HasVisibility
  include HasOwnership
  
  AVAILABILITIES = [:shop, :special, :loot, :mission, :gift]
  EFFECTS = [:attack, :defence, :health, :energy, :stamina]
  USAGE_TYPES = ["all", "attack", "defence"]

  belongs_to  :item_group
  has_many    :inventories, :dependent => :destroy

  has_many :item_elements
  has_many :elements, :through => :item_elements

  has_many :losses
  has_many :fights, :through => :losses

  named_scope :available, Proc.new{
    {
      :conditions => [%{
          (
            items.available_till IS NULL OR
            items.available_till > ?
          ) AND (
            items.limit IS NULL OR
            items.limit > items.owned
          )
        },
        Time.now
      ]
    }
  }

  named_scope :available_by_level, Proc.new {|character|
    {
      :conditions => ["items.level <= ?", character.level]
    }
  }

  named_scope :available_in, Proc.new{|*keys|
    valid_keys = keys.collect{|k| k.try(:to_sym) } & AVAILABILITIES # Find intersections between passed key list and available keys

    if valid_keys.any?
      valid_keys.collect!{|k| k.to_s }

      {:conditions => ["items.availability IN (?)", valid_keys]}
    else
      {}
    end
  }
  named_scope :next_for, Proc.new{|character|
    {
      :conditions => ["items.level > ? AND items.availability = 'shop' AND items.state = 'visible'", character.level],
      :order      => "items.level"
    }
  }

  named_scope :vip, {:conditions => "items.vip_price > 0"}
  named_scope :basic, {:conditions => "items.vip_price IS NULL or items.vip_price = 0"}

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

  has_attached_file :image,
    :styles => {
      :icon   => "50x50>",
      :small  => "72x72#",
      :medium => "120x120#",
      :large  => "200x200#",
      :stream => "90x90#"
    },
    :removable => true

  has_payouts :use,
    :visible => true
  has_requirements

  validates_presence_of :name, :item_group, :availability, :level
  validates_numericality_of :level, :basic_price, :vip_price, :allow_blank => true
  validates_numericality_of :package_size, 
    :greater_than => 0,
    :allow_blank  => true

  class << self
    def to_grouped_dropdown
      {}.tap do |result|
        ItemGroup.without_state(:deleted).all(:order => :position).each do |group|
          result[group.name] = group.items.without_state(:deleted).collect{|i|
            ["%s (%s)" % [i.name, i.availability], i.id]
          }
        end
      end
    end

    def available_for(character)
      visible_for(character).available_by_level(character)
    end

    def special_for(character)
      with_state(:visible).available.available_in(:special).available_for(character)
    end
    
    def gifts_for(character)
      with_state(:visible).available.available_in(:gift).available_for(character).scoped(:order => "items.level DESC")
    end
  end

  (Item::EFFECTS + %w{basic_price vip_price}).each do |attribute|
    class_eval %{
      def #{attribute}
        self[:#{attribute}] || 0
      end
    }
  end

  def price?
    basic_price > 0 or vip_price > 0
  end

  def effects?
    effects.any?
  end

  def effects
    unless @effects
      @effects = ActiveSupport::OrderedHash.new

      Item::EFFECTS.each do |effect|
        value = send(effect)

        @effects[effect] = value if value != 0
      end
    end

    @effects
  end

  def availability
    self[:availability].to_sym
  end

  def left
    limit.to_i > 0 ? limit - owned : nil
  end

  def time_left
    (available_till - Time.now).to_i
  end

  def plural_name
    self[:plural_name].blank? ? name.pluralize : self[:plural_name]
  end

  def placements
    boost? ? [] : self[:placements].to_s.split(",").collect{|p| p.to_sym }
  end

  def placements=(value)
    value = value.to_s.split(",") unless value.is_a?(Array)

    self[:placements] = value.join(",")
    self[:equippable] = self[:placements].present?
  end

  def placement_options_for_select
    placements.collect{|p|
      [Character::Equipment.placement_name(p), p]
    }
  end

  def requirements_satisfied?(character)
    requirements.satisfies?(character)
  end
  
  def package_size
    self[:package_size] || 1
  end

  def can_be_sold?
    self[:can_be_sold] && package_size == 1
  end
end
