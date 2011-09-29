class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.string :type, :limit => 100

      t.integer :character_id

      t.integer :reference_id
      t.string  :reference_type, :limit => 100

      t.string  :state, :limit => 50

      t.timestamps
    end
  end

  def self.down
    drop_table :notifications
  end
end
