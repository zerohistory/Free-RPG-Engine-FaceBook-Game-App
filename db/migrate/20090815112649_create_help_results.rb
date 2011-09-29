class CreateHelpResults < ActiveRecord::Migration
  def self.up
    create_table :help_results do |t|
      t.integer :help_request_id
      t.integer :character_id

      t.integer :money
      t.integer :experience
      
      t.timestamps
    end

    add_index :help_results, [:help_request_id, :character_id]
  end

  def self.down
    drop_table :help_results
  end
end
