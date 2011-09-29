class GlobalPayout < ActiveRecord::Base
  extend HasPayouts

  validates_presence_of :name, :alias
  
  has_payouts(*[MissionGroup, Item, ItemCollection, MonsterType, PropertyType, Story, Promotion].collect{|c| c.payout_events }.flatten.uniq)

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
  
  def self.by_alias(value)
    with_state(:visible).find_by_alias(value.to_s)
  end
end
