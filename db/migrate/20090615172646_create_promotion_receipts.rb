class CreatePromotionReceipts < ActiveRecord::Migration
  def self.up
    create_table :promotion_receipts do |t|
      t.integer :promotion_id
      t.integer :character_id

      t.timestamps
    end
  end

  def self.down
    drop_table :promotion_receipts
  end
end
