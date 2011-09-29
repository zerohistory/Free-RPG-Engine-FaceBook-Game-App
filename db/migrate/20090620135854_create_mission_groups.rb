class CreateMissionGroups < ActiveRecord::Migration
  def self.up
    create_table :mission_groups do |t|
      t.string  :name
      t.integer :level

      t.timestamps
    end

    add_column :missions, :mission_group_id, :integer
  end

  def self.down
    drop_table :mission_groups

    remove_column :missions, :mission_group_id
  end
end
