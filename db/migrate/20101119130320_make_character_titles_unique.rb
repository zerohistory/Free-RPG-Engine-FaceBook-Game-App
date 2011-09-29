class MakeCharacterTitlesUnique < ActiveRecord::Migration
  def self.up
    Rake::Task["app:maintenance:remove_duplicate_character_titles"].execute

    remove_index :character_titles, :column => [:character_id, :title_id]
    add_index :character_titles, [:character_id, :title_id], :unique => true
  end

  def self.down
    remove_index :character_titles, :column => [:character_id, :title_id]
    add_index :character_titles, [:character_id, :title_id]
  end
end
