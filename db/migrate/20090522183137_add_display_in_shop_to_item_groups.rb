class AddDisplayInShopToItemGroups < ActiveRecord::Migration
  def self.up
    add_column :item_groups, :display_in_shop, :boolean, :default => true
  end

  def self.down
    remove_column :item_groups, :display_in_shop
  end
end
