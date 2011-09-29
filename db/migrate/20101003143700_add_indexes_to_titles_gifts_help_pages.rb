class AddIndexesToTitlesGiftsHelpPages < ActiveRecord::Migration
  def self.up
    add_index :character_titles, [:character_id, :title_id]
    
    add_index :collection_ranks, [:character_id, :collection_id]

    add_index :gifts, :character_id

    add_index :help_pages, 'alias'

    add_index :hit_listings, :client_id

    add_index :market_items, :character_id

    add_index :mission_level_ranks, [:character_id, :level_id]
    add_index :mission_level_ranks, [:character_id, :mission_id]

    add_index :mission_levels, :mission_id

    add_index :notifications, :character_id

    add_index :visibilities, [:target_id, :target_type]
  end

  def self.down
    remove_index :character_titles, :column => [:character_id, :title_id]

    remove_index :collection_ranks, :column => [:character_id, :collection_id]

    remove_index :gifts, :column => :character_id

    remove_index :help_pages, :column => 'alias'

    remove_index :hit_listings, :column => :client_id

    remove_index :market_items, :column => :character_id

    remove_index :mission_level_ranks, :column => [:character_id, :level_id]
    remove_index :mission_level_ranks, :column => [:character_id, :mission_id]

    remove_index :mission_levels, :column => :mission_id

    remove_index :notifications, :column => :character_id

    remove_index :visibilities, :column => [:target_id, :target_type]
  end
end
