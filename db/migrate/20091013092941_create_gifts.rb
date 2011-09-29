class CreateGifts < ActiveRecord::Migration
  def self.up
    create_table :gifts do |t|
      t.integer :character_id
     
      t.integer :item_id

      t.text    :recipients
      t.integer :recipients_count
      
      t.integer :receipts_count

      t.timestamps
    end

    create_table :gift_receipts do |t|
      t.integer :gift_id
      t.integer :character_id

      t.timestamps
    end

    change_table :configurations do |t|
      t.boolean :gifting_enabled,                     :default => true
      t.integer :gifting_item_show_limit,             :default => 10
      t.integer :gifting_page_first_visit_delay,      :default => 1
      t.integer :gifting_page_recurrent_visit_delay,  :default => 24
    end

    change_table :users do |t|
      t.datetime :gift_page_visited_at
    end
  end

  def self.down
    drop_table :gifts
    drop_table :gift_receipts

    change_table :configurations do |t|
      t.remove :gifting_enabled
      t.remove :gifting_item_show_limit
      t.remove :gifting_page_first_visit_delay
      t.remove :gifting_page_recurrent_visit_delay
    end

    change_table :users do |t|
      t.remove :gift_page_visited_at
    end
  end
end
