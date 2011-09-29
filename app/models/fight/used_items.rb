class Fight
  module UsedItems
    def used_items
      items = inventories.equipped.all(:include => {:item => :item_group})

      groups = ItemGroup.with_state(:visible).all(:order => :position)

      ActiveSupport::OrderedHash.new.tap do |result|
        groups.each do |group|
          items_by_group = items.select{|i| i.item_group == group }

          result[group] = items_by_group if items_by_group.any?
        end
      end
    end
  end
end
