class AddCharacterDefaultNameToConfigurations < ActiveRecord::Migration
  def self.up
    change_table :configurations do |t|
      t.string :character_default_name, :limit => 100
    end
  end

  def self.down
    change_table :configurations do |t|
      t.remove :character_default_name
    end
  end
end
