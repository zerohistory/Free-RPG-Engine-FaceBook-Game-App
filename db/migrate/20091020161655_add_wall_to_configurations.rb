class AddWallToConfigurations < ActiveRecord::Migration
  def self.up
    change_table :configurations do |t|
      t.boolean :wall_enabled, :default => true

      t.integer :wall_posts_show_limit, :default => 10
    end
  end

  def self.down
    change_table :configurations do |t|
      t.remove :wall_enabled
      t.remove :wall_posts_show_limit
    end
  end
end
