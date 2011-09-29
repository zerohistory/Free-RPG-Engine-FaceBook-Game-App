class CreateMissionLevels < ActiveRecord::Migration
  def self.up
    create_table :mission_levels do |t|
      t.integer :mission_id
      t.integer :position

      t.integer :win_amount
      t.integer :chance,  :default => 100
      t.integer :energy
      t.integer :experience
      t.integer :money_min
      t.integer :money_max
      t.text    :payouts

      t.timestamps
    end

    change_table :missions do |t|
      t.integer :levels_count, :default => 0
    end

    create_table :mission_level_ranks do |t|
      t.integer :character_id
      t.integer :mission_id
      t.integer :level_id

      t.integer :progress,  :default => 0
      t.boolean :completed, :default => false

      t.timestamps
    end

    rename_table :ranks, :mission_ranks

    Rake::Task["app:maintenance:move_mission_attributes_to_levels"].execute

    change_table :mission_ranks do |t|
      t.remove :win_count
    end
  end

  def self.down
    rename_table :mission_ranks, :ranks

    change_table :ranks do |t|
      t.integer :win_count, :default => 0
    end

    drop_table :mission_level_ranks

    change_table :missions do |t|
      t.remove :levels_count
    end

    drop_table :mission_levels
  end
end
