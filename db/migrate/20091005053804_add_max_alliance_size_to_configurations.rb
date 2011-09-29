class AddMaxAllianceSizeToConfigurations < ActiveRecord::Migration
  def self.up
    add_column :configurations, :relation_max_alliance_size, :integer, :default => 500
  end

  def self.down
    remove_column :configurations, :relation_max_alliance_size
  end
end
