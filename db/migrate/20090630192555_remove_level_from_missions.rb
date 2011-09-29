class RemoveLevelFromMissions < ActiveRecord::Migration
  def self.up
    remove_column :missions, :level
  end

  def self.down
    add_column :missions, :level, :integer
  end
end
