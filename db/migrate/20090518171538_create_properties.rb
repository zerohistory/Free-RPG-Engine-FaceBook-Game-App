class CreateProperties < ActiveRecord::Migration
  def self.up
    create_table :properties do |t|
      t.integer :property_type_id
      t.integer :character_id

      t.timestamps
    end

    add_column :characters, :property_income, :integer, :default => 0
    add_column :characters, :basic_money_updated_at, :datetime
  end

  def self.down
    drop_table :properties

    remove_column :characters, :property_income
    remove_column :characters, :basic_money_updated_at
  end
end
