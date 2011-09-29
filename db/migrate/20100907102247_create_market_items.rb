class CreateMarketItems < ActiveRecord::Migration
  def self.up
    create_table :market_items do |t|
      t.integer :character_id
      t.integer :inventory_id

      t.integer :amount

      t.integer :basic_price
      t.integer :vip_price
      
      t.timestamps
    end

    change_table :inventories do |t|
      t.integer :market_items_count, :default => 0
    end

    change_table :items do |t|
      t.boolean :can_be_sold_on_market
    end
  end

  def self.down
    drop_table :market_items

    change_table :inventories do |t|
      t.remove :market_items_count
    end
    
    change_table :items do |t|
      t.remove :can_be_sold_on_market
    end
  end
end
