class MigrateMissionLootToPayouts < ActiveRecord::Migration
  def self.up
    Rake::Task['app:maintenance:convert_loot_to_random_payout'].execute

    change_table :missions do |t|
      t.remove "allow_loot"
      t.remove "loot_chance"
      t.remove "loot_item_ids"
    end
  end

  def self.down
    change_table :missions do |t|
      t.boolean  "allow_loot"
      t.integer  "loot_chance",   :default => 10
      t.string   "loot_item_ids", :default => "",  :null => false
    end
  end
end
