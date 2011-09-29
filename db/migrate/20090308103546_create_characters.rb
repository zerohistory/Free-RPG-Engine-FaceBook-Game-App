class CreateCharacters < ActiveRecord::Migration
  def self.up
    create_table :characters do |t|
      t.integer :user_id

      t.string  :name

      t.integer :basic_money, :default => 10
      t.integer :vip_money,   :default => 0

      t.integer :level,       :default => 1
      t.integer :experience,  :default => 0
      t.integer :points,      :default => 0

      t.integer :attack,      :default => 1
      t.integer :defence,     :default => 1

      t.integer :hp,          :default => 100
      t.integer :health,      :default => 100

      t.integer :ep,          :default => 10
      t.integer :energy,      :default => 10

      t.text    :inventory_effects

      t.datetime :hp_updated_at
      t.datetime :ep_updated_at
      
      t.timestamps
    end
  end

  def self.down
    drop_table :characters
  end
end
