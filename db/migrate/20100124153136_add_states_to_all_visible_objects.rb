class AddStatesToAllVisibleObjects < ActiveRecord::Migration
  TABLES = %w{bosses item_groups items mission_groups missions property_types}

  def self.up
    TABLES.each do |t|
      add_column t, :state, :string, :limit => 30
    end

    puts "\nRun rake app:maintenance:set_default_states to update default states\n\n"
  end

  def self.down
    TABLES.each do |t|
      remove_column t, :state
    end
  end
end
