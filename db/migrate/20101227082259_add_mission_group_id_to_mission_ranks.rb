class AddMissionGroupIdToMissionRanks < ActiveRecord::Migration
  def self.up
    change_table :mission_ranks do |t|
      t.integer :mission_group_id
    end

    MissionRank.update_all "mission_group_id = (SELECT mission_group_id FROM missions WHERE missions.id = mission_ranks.mission_id)"
  end

  def self.down
    change_table :mission_ranks do |t|
      t.remove :mission_group_id
    end
  end
end
