class CreateStuffInvisibilities < ActiveRecord::Migration
  def self.up
    create_table :stuff_invisibilities do |t|
      t.integer :stuff_id
      t.string  :stuff_type
      t.integer :character_type_id
      t.timestamps
    end
  end

  def self.down
    drop_table :stuff_invisibilities
  end
end
