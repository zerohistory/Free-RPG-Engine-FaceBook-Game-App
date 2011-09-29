class ItemCollectionRank < ActiveRecord::Base
  belongs_to :character
  belongs_to :collection, :class_name => "ItemCollection"

  attr_reader :payouts, :applied

  validate :check_items

  def apply!
    return unless valid?

    transaction do
      @payouts = collection.payouts.apply(character, (collected? ? :repeat_collected : :collected), collection)
      @payouts += collection.spendings.apply(character, :collected, collection)

      increment(:collection_count)

      character.save
      save

      @applied = true
    end
  end

  def collected?
    collection_count > 0
  end

  protected

  def check_items
    unless character.items.count(:conditions => {:id => collection.item_ids}) == collection.item_ids.size
      errors.add(:character, :not_enough_items)
    end
  end
end
