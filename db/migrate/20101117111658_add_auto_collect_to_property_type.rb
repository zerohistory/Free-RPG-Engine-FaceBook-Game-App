class AddAutoCollectToPropertyType < ActiveRecord::Migration
  def self.up
    add_column :property_types, :auto_collect, :boolean, :default => false
  end

  def self.down
    remove_column :property_types, :auto_collect
  end
end
