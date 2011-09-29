class AddParentMissionToMissions < ActiveRecord::Migration
  def self.up
    add_column :missions, :parent_mission_id, :integer
  end

  def self.down
    add_column :missions, :parent_mission_id
  end
end
