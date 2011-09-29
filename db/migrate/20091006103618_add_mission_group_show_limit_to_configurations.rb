class AddMissionGroupShowLimitToConfigurations < ActiveRecord::Migration
  def self.up
    add_column :configurations, :mission_group_show_limit, :integer, :default => 4
  end

  def self.down
    remove_column :configurations, :mission_group_show_limit
  end
end
