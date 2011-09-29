class AddLockingVersionToBossFights < ActiveRecord::Migration
  def self.up
    change_table :boss_fights do |t|
      t.integer :lock_version, :default => 0
    end
  end

  def self.down
    change_table :boss_fights do |t|
      t.remove :lock_version
    end
  end
end
