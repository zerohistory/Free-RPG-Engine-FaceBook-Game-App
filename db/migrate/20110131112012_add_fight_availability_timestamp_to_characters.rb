class AddFightAvailabilityTimestampToCharacters < ActiveRecord::Migration
  def self.up
    change_table :characters do |t|
      t.datetime :fighting_available_at, :default => Time.at(0)
    end
    
    remove_index  :characters, :column => :level
    add_index     :characters, [:level, :fighting_available_at], :name => "by_level_and_fighting_time"
  end

  def self.down
    change_table :characters do |t|
      t.remove :fighting_available_at
    end
    
    add_index :characters, :level
  end
end
