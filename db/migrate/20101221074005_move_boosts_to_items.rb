class MoveBoostsToItems < ActiveRecord::Migration
  def self.up
    change_table :items do |t|
      t.boolean :boost
    end
    
    Item.reset_column_information

    Rake::Task['app:maintenance:convert_boosts_to_items'].execute

    drop_table :boosts
    drop_table :purchased_boosts
  end

  def self.down
    create_table "boosts" do |t|
      t.string   "name",               :limit => 100, :default => "", :null => false
      t.string   "description",                       :default => "", :null => false
      t.integer  "level"
      t.integer  "attack",                            :default => 0
      t.integer  "defence",                           :default => 0
      t.integer  "damage",                            :default => 0
      t.integer  "basic_price",                       :default => 0
      t.integer  "vip_price",                         :default => 0
      t.string   "image_file_name",                   :default => "", :null => false
      t.string   "image_content_type", :limit => 100, :default => "", :null => false
      t.integer  "image_file_size"
      t.string   "state",              :limit => 50,  :default => "", :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.datetime "image_updated_at"
    end

    create_table "purchased_boosts" do |t|
      t.integer  "character_id"
      t.integer  "boost_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    change_table :items do |t|
      t.remove :boost
    end
  end
end
