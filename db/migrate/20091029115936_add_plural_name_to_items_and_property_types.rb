class AddPluralNameToItemsAndPropertyTypes < ActiveRecord::Migration
  def self.up
    add_column :items, :plural_name, :string
    add_column :property_types, :plural_name, :string
  end

  def self.down
    remove_column :items, :plural_name
    remove_column :property_types, :plural_name
  end
end
