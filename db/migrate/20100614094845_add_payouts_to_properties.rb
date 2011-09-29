class AddPayoutsToProperties < ActiveRecord::Migration
  def self.up
    change_table :property_types do |t|
      t.text :payouts
    end
  end

  def self.down
    change_table :property_types do |t|
      t.remove :payouts
    end
  end
end
