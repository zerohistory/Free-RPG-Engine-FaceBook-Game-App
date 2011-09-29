class AddPayoutsAndTitlesToMissionGroups < ActiveRecord::Migration
  def self.up
    add_column :mission_groups, :payouts, :text
    add_column :mission_groups, :title, :string

    create_table :mission_group_ranks do |t|
      t.integer :character_id
      t.integer :mission_group_id
      
      t.boolean :completed
    end
  end

  def self.down
    remove_column :mission_groups, :payouts
    remove_column :mission_groups, :title

    drop_table :mission_group_ranks
  end
end
