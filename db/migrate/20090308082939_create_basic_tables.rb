class CreateBasicTables < ActiveRecord::Migration
  def self.up
    create_table "delayed_jobs", :force => true do |t|
      t.integer  "priority",   :default => 0
      t.integer  "attempts",   :default => 0
      t.text     "handler"
      t.string   "last_error"
      t.datetime "run_at"
      t.datetime "locked_at"
      t.datetime "failed_at"
      t.string   "locked_by"
      
      t.timestamps
    end

    create_table "facebook_templates", :force => true do |t|
      t.string "template_name", :null => false
      t.string "content_hash",  :null => false
      t.string "bundle_id"
    end

    add_index "facebook_templates", ["template_name"], :name => "index_facebook_templates_on_template_name", :unique => true

    create_table "users", :force => true do |t|
      t.integer  "facebook_id",     :limit => 8
      t.boolean  "show_next_steps",              :default => true

      t.timestamps
    end

    add_index "users", ["facebook_id"], :name => "index_users_on_facebook_id"
  end

  def self.down
    drop_table :delayed_jobs
    drop_table :facebook_templates
    drop_table :users
  end
end
