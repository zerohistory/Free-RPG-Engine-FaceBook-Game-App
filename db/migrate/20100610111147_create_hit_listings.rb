class CreateHitListings < ActiveRecord::Migration
  def self.up
    create_table :hit_listings do |t|
      t.belongs_to  :client
      t.belongs_to  :victim
      t.belongs_to  :executor

      t.integer   :reward

      t.boolean   :completed, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :hit_listings
  end
end
