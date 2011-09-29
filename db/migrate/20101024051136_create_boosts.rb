class CreateBoosts < ActiveRecord::Migration
  def self.up
    create_table :boosts do |t|
      t.string  :name
      t.string  :description
      t.integer :level
      t.integer :attack, :default => 0
      t.integer :defence, :default => 0
      t.integer :damage, :default => 0
      t.integer :basic_price, :default => 0
      t.integer :vip_price, :default => 0
      t.string  :image_file_name
      t.string  :image_content_type
      t.integer :image_file_size
      t.string  :state, :limit => 30
      t.timestamps
    end
  end

  def self.down
    drop_table :boosts
  end
end
