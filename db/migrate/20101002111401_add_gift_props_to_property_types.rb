class AddGiftPropsToPropertyTypes < ActiveRecord::Migration
  def self.up
    add_column :property_types, :can_be_gifted, :boolean, :default => false
    add_column :property_types, :gift_cost, :integer, :default => 0
  end

  def self.down
    remove_column :property_types, :gift_cost
    remove_column :property_types, :can_be_gifted
  end
end
