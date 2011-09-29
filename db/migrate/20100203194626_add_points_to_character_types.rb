class AddPointsToCharacterTypes < ActiveRecord::Migration
  def self.up
    change_table :character_types do |t|
      t.integer :points, :default => 0
    end
  end

  def self.down
    change_table :character_types do |t|
      t.remove :points
    end
  end
end
