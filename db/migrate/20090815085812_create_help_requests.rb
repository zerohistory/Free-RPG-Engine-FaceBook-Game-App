class CreateHelpRequests < ActiveRecord::Migration
  def self.up
    create_table :help_requests do |t|
      t.integer :character_id
      t.integer :mission_id

      t.integer :help_results_count,  :default => 0
      t.integer :money,               :default => 0

      t.timestamps
    end

    add_index :help_requests, :character_id
  end

  def self.down
    drop_table :help_requests
  end
end
