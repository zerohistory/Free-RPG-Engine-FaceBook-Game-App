class AddIndexesToBossFightsAndSomeOthers < ActiveRecord::Migration
  def self.up
    add_index :boss_fights, [:character_id, :boss_id]
    add_index :bosses, :mission_group_id

    add_index :assets, "alias"

    add_index :gift_receipts, [:character_id, :gift_id]

    add_index :mission_group_ranks, [:character_id, :mission_group_id]
    add_index :missions, :mission_group_id

    add_index :promotion_receipts, [:character_id, :promotion_id]
  end

  def self.down
    remove_index :boss_fights, :column => [:character_id, :boss_id]
    remove_index :bosses, :column => :mission_group_id

    remove_index :assets, :column => "alias"

    remove_index :gift_receipts, :column => [:character_id, :gift_id]

    remove_index :mission_group_ranks, :column => [:character_id, :mission_group_id]
    remove_index :missions, :column => :mission_group_id

    remove_index :promotion_receipts, :column => [:character_id, :promotion_id]
  end
end
