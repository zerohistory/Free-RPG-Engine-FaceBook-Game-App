class CreateMissionHelpResults < ActiveRecord::Migration
  def self.up
    create_table :mission_help_results do |t|
      t.integer :character_id
      t.integer :requester_id
      t.integer :mission_id
      
      t.integer :basic_money
      t.integer :experience
      
      t.boolean :collected, :null => false, :default => false
      
      t.timestamps
    end
    
    add_index :mission_help_results, [:character_id, :requester_id]
    add_index :mission_help_results, [:requester_id, :collected]

    drop_table :help_requests
    drop_table :help_results
  end

  def self.down
    drop_table :mission_help_results

    create_table "help_requests" do |t|
      t.integer  "character_id"
      t.integer  "context_id"
      t.integer  "help_results_count",               :default => 0
      t.integer  "money",              :limit => 8,  :default => 0
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "context_type",       :limit => 50, :default => "", :null => false
      t.integer  "experience",                       :default => 0
    end

    add_index "help_requests", ["character_id"], :name => "index_help_requests_on_character_id"
    
    create_table "help_results" do |t|
      t.integer  "help_request_id"
      t.integer  "character_id"
      t.integer  "money"
      t.integer  "experience"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "help_results", ["help_request_id", "character_id"], :name => "index_help_results_on_help_request_id_and_character_id"
  end
end
