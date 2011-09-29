class AddIndexToNews < ActiveRecord::Migration
  def self.up
    add_index :news, :character_id
  end

  def self.down
    remove_index :news, :character_id
  end
end
