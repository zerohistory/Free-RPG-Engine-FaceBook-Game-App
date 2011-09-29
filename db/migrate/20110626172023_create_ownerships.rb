class CreateOwnerships < ActiveRecord::Migration
  def self.up
    create_table :ownerships do |t|
      t.integer :target_id
      t.string  :target_type
      t.integer :character_type_id
      t.timestamps
    end
  end

  def self.down
    drop_table :ownerships
  end
end
