class AddGiftPropsToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :can_be_gifted, :boolean, :default => true
    add_column :items, :gift_cost, :integer, :default => 0
  end

  def self.down
    remove_column :items, :gift_cost
    remove_column :items, :can_be_gifted
  end
end
