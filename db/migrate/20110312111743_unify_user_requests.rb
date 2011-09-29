class UnifyUserRequests < ActiveRecord::Migration
  def self.up
    change_table :app_requests do |t|
      t.datetime "visited_at"
      
      t.string   "type",        :limit => 50, :default => "", :null => false
    end
    
    Rake::Task['app:maintenance:unify_requests'].execute
    
    drop_table :invitations
    drop_table :gifts
    
    change_table :users do |t|
      t.remove :landing_visited_at
      t.remove :last_landing
      t.remove :show_next_steps
    end
  end

  def self.down
    change_table :users do |t|
      t.boolean  "show_next_steps",                       :default => true
      t.datetime "landing_visited_at"
      t.string   "last_landing",           :limit => 100, :default => "",      :null => false
    end

    change_table :app_requests do |t|
      t.remove "visited_at"
      t.remove "type"
    end
    
    create_table "invitations" do |t|
      t.integer  "sender_id",                   :null => false
      t.integer  "receiver_id",    :limit => 8, :null => false
      t.boolean  "accepted"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "app_request_id"
    end
    
    create_table "gifts" do |t|
      t.integer  "app_request_id"
      t.integer  "sender_id",                                    :null => false
      t.integer  "receiver_id",    :limit => 8,                  :null => false
      t.integer  "item_id"
      t.string   "state",          :limit => 50, :default => "", :null => false
      t.datetime "accepted_at"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
