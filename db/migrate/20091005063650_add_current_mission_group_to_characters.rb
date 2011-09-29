class AddCurrentMissionGroupToCharacters < ActiveRecord::Migration
  def self.up
    add_column :characters, :current_mission_group_id, :integer
  end

  def self.down
    remove_column :characters, :current_mission_group_id
  end
end
