class CreateVipMoneyOperations < ActiveRecord::Migration
  def self.up
    create_table :vip_money_operations do |t|
      t.string  :type, :limit => 100

      t.integer :character_id

      t.integer :amount
      
      t.integer :reference_id
      t.string  :reference_type, :limit => 100

      t.timestamps
    end
  end

  def self.down
    drop_table :vip_money_operations
  end
end
