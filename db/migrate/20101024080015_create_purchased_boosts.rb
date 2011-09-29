class CreatePurchasedBoosts < ActiveRecord::Migration
  def self.up
    create_table :purchased_boosts do |t|
      t.integer :character_id
      t.integer :boost_id

      t.timestamps
    end
  end

  def self.down
    drop_table :purchased_boosts
  end
end
