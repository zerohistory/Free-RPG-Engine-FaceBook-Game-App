class AddLockVersionToCharacters < ActiveRecord::Migration
  def self.up
    change_table :characters do |t|
      t.integer :lock_version, :default => 0
    end
  end

  def self.down
    change_table :characters do |t|
      t.remove :lock_version
    end
  end
end
