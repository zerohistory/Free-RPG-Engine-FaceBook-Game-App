class MakeMissionAndLevelRanksUnique < ActiveRecord::Migration
  def self.up
    Rake::Task["app:maintenance:remove_duplicate_ranks"].execute

    remove_index :mission_level_ranks, :column => [:character_id, :level_id]
    add_index :mission_level_ranks, [:character_id, :level_id], :unique => true

    remove_index :mission_ranks, :column => [:character_id, :mission_id]
    add_index :mission_ranks, [:character_id, :mission_id], :unique => true

    Rake::Task["app:maintenance:recalculate_mission_stats"].execute
  end

  def self.down
    remove_index :mission_level_ranks, :column => [:character_id, :level_id]
    add_index :mission_level_ranks, [:character_id, :level_id]

    remove_index :mission_ranks, :column => [:character_id, :mission_id]
    add_index :mission_ranks, [:character_id, :mission_id]
  end
end
