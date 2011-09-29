class CreatePromotions < ActiveRecord::Migration
  def self.up
    create_table :promotions do |t|
      t.string    :text
      t.text      :payouts

      t.datetime  :valid_till

      t.integer   :promotion_receipts_count, :default => 0
      
      t.timestamps
    end
  end

  def self.down
    drop_table :promotions
  end
end
