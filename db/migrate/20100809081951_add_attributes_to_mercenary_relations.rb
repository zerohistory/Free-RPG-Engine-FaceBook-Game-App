class AddAttributesToMercenaryRelations < ActiveRecord::Migration
  def self.up
    change_table :relations do |t|
      t.integer :level, :attack, :defence, :health, :energy, :stamina
      
      t.rename :source_id, :owner_id
      t.rename :target_id, :character_id
    end

    Rake::Task["app:maintenance:assign_attributes_to_mercenaries"].execute
  end

  def self.down
    change_table :relations do |t|
      t.remove :level, :attack, :defence, :health, :energy, :stamina

      t.rename :owner_id,     :source_id
      t.rename :character_id, :target_id
    end
  end
end
