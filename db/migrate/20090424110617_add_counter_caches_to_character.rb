class AddCounterCachesToCharacter < ActiveRecord::Migration
  def self.up
    add_column :characters, :fights_won, :integer, :default => 0
    add_column :characters, :fights_lost, :integer, :default => 0
    add_column :characters, :missions_succeeded, :integer, :default => 0
    add_column :characters, :missions_completed, :integer, :default => 0
    
    add_column :characters, :relations_count, :integer, :default => 0
  end

  def self.down
    remove_column :characters, :fights_won
    remove_column :characters, :fights_lost
    remove_column :characters, :missions_succeeded
    remove_column :characters, :missions_completed
    
    remove_column :characters, :relations_count
  end
end
