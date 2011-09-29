class AddDefaultValueToOwnedItems < ActiveRecord::Migration
  def self.up
    change_column :items, :owned, :integer, :default => 0
    
    puts "\nRun rake app:maintenance:set_defaults_to_owned_items to update defaults to existing items\n\n"
  end

  def self.down
    change_column :items, :owned, :integer, :default => nil
  end
end
