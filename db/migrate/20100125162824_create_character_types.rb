class CreateCharacterTypes < ActiveRecord::Migration
  def self.up
    create_table :character_types do |t|
      t.string  :name, :limit => 100
      t.text    :description, :limit => 2048

      t.integer :basic_money, :default => 10
      t.integer :vip_money,   :default => 0

      t.integer :attack,      :default => 1
      t.integer :defence,     :default => 1

      t.integer :health,      :default => 100
      t.integer :energy,      :default => 10

      t.string  :image_file_name
      t.string  :image_content_type
      t.integer :image_file_size

      t.string  :state, :limit => 30

      t.integer :characters_count

      t.timestamps
    end

    change_table :characters do |t|
      t.integer :character_type_id
    end
  end

  def self.down
    drop_table :character_types

    change_table :characters do |t|
      t.remove :character_type_id
    end
  end
end
