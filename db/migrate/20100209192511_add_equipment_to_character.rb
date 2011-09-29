class AddEquipmentToCharacter < ActiveRecord::Migration
  def self.up
    change_table :characters do |t|
      t.text :placements, :limit => 65535
    end

    change_table :inventories do |t|
      t.remove :placement
      t.remove :use_in_fight
      
      t.integer :equipped, :default => 0
    end

    change_table :items do |t|
      t.boolean :equippable, :default => false
    end

    change_table :character_types do |t|
      t.integer :equipment_slots, :default => 5
    end

    change_table :configurations do |t|
      t.integer :character_equipment_slots, :default => 5
      t.integer :character_relations_per_equipment_slot, :default => 3
    end
  end

  def self.down
    change_table :characters do |t|
      t.remove :placements
    end

    change_table :inventories do |t|
      t.string  :placement
      t.integer :use_in_fight, :default => 0

      t.remove :equipped
    end

    change_table :items do |t|
      t.remove :equippable
    end

    change_table :character_types do |t|
      t.remove :equipment_slots
    end

    change_table :configurations do |t|
      t.remove :character_equipment_slots
      t.remove :character_relations_per_equipment_slot
    end
  end
end
