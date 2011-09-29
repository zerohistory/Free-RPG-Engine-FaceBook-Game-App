class AddPositionToMissionGroups < ActiveRecord::Migration
  def self.up
    change_table :mission_groups do |t|
      t.integer :position
    end

    Rake::Task["app:maintenance:add_positions_to_mission_groups"].execute
    Rake::Task["app:maintenance:convert_mission_group_levels_to_requirements"].execute

    change_table :mission_groups do |t|
      t.remove :level
    end
  end

  def self.down
    change_table :mission_groups do |t|
      t.remove  :position
      t.integer :level
    end
  end
end
