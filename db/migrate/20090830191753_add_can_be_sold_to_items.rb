class AddCanBeSoldToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :can_be_sold, :boolean, :default => true
  end

  def self.down
    remove_column :items, :can_be_sold
  end
end
