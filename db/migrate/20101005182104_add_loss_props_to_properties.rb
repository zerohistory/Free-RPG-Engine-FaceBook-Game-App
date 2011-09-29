class AddLossPropsToProperties < ActiveRecord::Migration
  def self.up
    add_column :property_types, :can_be_lost, :boolean, :default => false
    add_column :property_types, :can_be_found, :boolean, :default => false
  end

  def self.down
    remove_column :property_types, :can_be_found
    remove_column :property_types, :can_be_lost
  end
end
