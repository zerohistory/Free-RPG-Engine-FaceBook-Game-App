class AddInflationToProperties < ActiveRecord::Migration
  def self.up
    add_column :property_types, :inflation, :integer
  end

  def self.down
    remove_column :property_types, :inflation
  end
end
