class Property < ActiveRecord::Base
  belongs_to :character
  belongs_to :property_type

  delegate :name, :plural_name, :description, :image, :image?, :basic_price, :vip_price, :income, :collect_period, :payouts, :auto_collect,
    :to => :property_type

  attr_accessor :charge_money

  validate :enough_character_money?
  validate_on_update :check_upgrade_possibility

  after_create :assign_collected_at

  named_scope :auto_collectable, :include => [:property_type], :conditions => ["property_types.auto_collect = true"]

  def maximum_level
    property_type.upgrade_limit || Setting.i(:property_upgrade_limit)
  end

  def upgrade_price
    property_type.upgrade_price(level)
  end

  def upgradeable?
    level < maximum_level
  end

  def collectable?
    collected_at < Time.now - collect_period.hours
  end

  def total_income
    income * level
  end

  def time_to_next_collection
    collectable? ? 0 : (collected_at + collect_period.hours).to_i - Time.now.to_i
  end

  def buy!
    @validate_money = true

    if valid?
      transaction do
        if save! && character.charge!(basic_price, vip_price, property_type)
          character.news.add(:property_purchase, :property_id => property_type_id)

          true
        else
          false
        end
      end
    else
      false
    end
  end

  def upgrade!
    return false if new_record?

    @validate_money = true

    if valid?
      transaction do
        increment(:level)

        save(false) && character.charge!(property_type.upgrade_price(level - 1), vip_price, property_type)

        character.news.add(:property_upgrade, :property_id => id, :level => level)
      end
    else
      false
    end
  end

  def collect_money!
    if collectable?
      transaction do
        update_attribute(:collected_at, Time.now)

        result = payouts.apply(character, :collect, property_type)

        result << Payouts::BasicMoney.new(:value => total_income)

        character.charge!(- total_income, 0, self)

        character.news.add(:property_collect, :property_id => property_type_id, :payouts => result)

        result
      end
    else
      false
    end
  end
  
       def self.collectable_total(properties)
	  unless @collectable
          @collectable = []

          properties.each do |property|
            @collectable << property if property.collectable?
          end
        end

        @collectable
       end

      def collect_money_total!(properties)
        result = Payouts::Collection.new

        transaction do
          properties.each do |property|
            if collected = property.collect_money!
              result += collected
            end
          end
        end

        result.any? ? result : false
      end
     

  def can_be_gifted?
    property_type.can_be_gifted
  end

  def validate
    unless property_type.requirements_satisfied?(character)
      rejected_properties = property_type.requirements.by_type(:rejected_property)
      if rejected_properties
        errors.add(:property_type, I18n::t("properties.errors.rejected_properties",
                                   :property_type => property_type.name,
                                   :properties => rejected_properties.collect{|r| r.property.name}.join(", ")))
      else
        errors.add(:property_type, t("properties.errors.requirements_not_satisfied"))
      end
    end
  end

  protected

  def check_upgrade_possibility
    unless upgradeable?
      errors.add(:character, :too_much_properties, :plural_name => plural_name)
    end
  end

  def enough_character_money?
    if @validate_money
      if character.basic_money < (new_record? ? basic_price : upgrade_price)
        errors.add(:character, new_record? ? :not_enough_basic_money : :not_enough_basic_money_for_upgrade,
          :name         => name,
          :basic_money  => Character.human_attribute_name("basic_money")
        )
      end

      if character.vip_money < vip_price
        errors.add(:character, new_record? ? :not_enough_vip_money : :not_enough_vip_money_for_upgrade,
          :name       => name,
          :vip_money  => Character.human_attribute_name("vip_money")
        )
      end
    end
  end

  def assign_collected_at
    update_attribute(:collected_at, created_at)
  end
end
