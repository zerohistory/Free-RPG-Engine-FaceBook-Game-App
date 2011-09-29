class AddAmountToProperties < ActiveRecord::Migration
  def self.up
    add_column    :properties, :amount, :integer, :default => 0
    rename_column :property_types, :money_min, :income
    remove_column :property_types, :money_max
  end

  def self.down
    remove_column :properties, :amount
    rename_column :property_types, :income, :money_min
    add_column    :property_types, :money_max, :integer
    
    PropertyType.update_all("money_max = money_min")
  end
end
