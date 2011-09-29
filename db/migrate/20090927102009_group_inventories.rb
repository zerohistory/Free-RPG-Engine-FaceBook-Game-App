class GroupInventories < ActiveRecord::Migration
  def self.up
    add_column :inventories, :amount, :integer, :default => 0
    add_column :inventories, :use_in_fight, :integer, :default => 0
    add_column :items, :attack, :integer, :default => 0
    add_column :items, :defence, :integer, :default => 0
  end

  def self.down
    remove_column :inventories, :amount
  end
end
