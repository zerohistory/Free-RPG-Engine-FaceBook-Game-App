class AddLootToMissions < ActiveRecord::Migration
  def self.up
    add_column :missions, :allow_loot,  :boolean
    add_column :missions, :loot_chance, :integer, :default => 10
    add_column :missions, :loot_item_ids,  :string
  end

  def self.down
    remove_column :missions, :allow_loot
    remove_column :missions, :loot_chance
    remove_column :missions, :loot_items
  end
end
