class AddMissionsMasteredCountToCharacters < ActiveRecord::Migration
  def self.up
    change_table :characters do |t|
      t.integer :missions_mastered, :default => 0
    end

    Rake::Task["app:maintenance:update_missions_mastered_count"].execute
  end

  def self.down
    change_table :characters do |t|
      t.remove :missions_mastered
    end
  end
end
