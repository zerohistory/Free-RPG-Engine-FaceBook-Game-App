module ItemCollectionsHelper
  def collection_items(collection)
    collection.items.each do |item|
      inventory = current_character.inventories.detect{|inventory| inventory.item_id == item.id }

      yield(item, inventory)
    end
  end
end
