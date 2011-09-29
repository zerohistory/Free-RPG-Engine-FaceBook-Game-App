class AddPurchaseLimitToPropertyTypes < ActiveRecord::Migration
  def self.up
    add_column :property_types, :purchase_limit, :integer
  end

  def self.down
    remove_column :property_types, :purchase_limit
  end
end
