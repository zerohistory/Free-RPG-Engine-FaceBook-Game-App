class CreatePropertyTypes < ActiveRecord::Migration
  def self.up
    create_table :property_types do |t|
      t.string  :name
      t.text    :description

      t.string  :availability, :limit => 30, :default => "shop"
      t.integer :level

      t.integer :basic_price
      t.integer :vip_price

      t.string  :image_file_name
      t.string  :image_content_type
      t.integer :image_file_size

      t.integer :money_min
      t.integer :money_max

      t.text    :requirements

      t.timestamps
    end
  end

  def self.down
    drop_table :property_types
  end
end
