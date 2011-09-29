# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110324095627) do

  create_table "app_requests", :force => true do |t|
    t.integer  "facebook_id",  :limit => 8,                  :null => false
    t.integer  "sender_id"
    t.integer  "receiver_id",  :limit => 8
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",        :limit => 50, :default => "", :null => false
    t.datetime "processed_at"
    t.datetime "accepted_at"
    t.datetime "visited_at"
    t.string   "type",         :limit => 50, :default => "", :null => false
  end

  add_index "app_requests", ["facebook_id"], :name => "index_app_requests_on_facebook_id"

  create_table "assets", :force => true do |t|
    t.string   "alias",              :limit => 200, :default => "", :null => false
    t.string   "image_file_name",                   :default => "", :null => false
    t.string   "image_content_type", :limit => 100, :default => "", :null => false
    t.integer  "image_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "image_updated_at"
  end

  add_index "assets", ["alias"], :name => "index_assets_on_alias"

  create_table "assignments", :force => true do |t|
    t.integer  "relation_id"
    t.integer  "context_id",                                 :null => false
    t.string   "context_type", :limit => 50, :default => "", :null => false
    t.string   "role",         :limit => 50, :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignments", ["context_id", "context_type"], :name => "index_assignments_on_context_id_and_context_type"
  add_index "assignments", ["relation_id"], :name => "index_assignments_on_relation_id"

  create_table "bank_operations", :force => true do |t|
    t.integer  "character_id",                               :null => false
    t.integer  "amount",       :limit => 8
    t.string   "type",         :limit => 50, :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bank_operations", ["character_id"], :name => "index_bank_operations_on_character_id"

  create_table "boss_fights", :force => true do |t|
    t.integer  "boss_id"
    t.integer  "character_id"
    t.integer  "health"
    t.datetime "expire_at"
    t.string   "state",        :limit => 50, :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",               :default => 0
  end

  add_index "boss_fights", ["character_id", "boss_id"], :name => "index_boss_fights_on_character_id_and_boss_id"

  create_table "bosses", :force => true do |t|
    t.integer  "mission_group_id"
    t.string   "name",               :limit => 100, :default => "", :null => false
    t.text     "description"
    t.integer  "health"
    t.integer  "attack"
    t.integer  "defence"
    t.integer  "ep_cost"
    t.integer  "experience"
    t.text     "requirements"
    t.text     "payouts"
    t.string   "image_file_name",                   :default => "", :null => false
    t.string   "image_content_type", :limit => 100, :default => "", :null => false
    t.integer  "image_file_size"
    t.integer  "time_limit",                        :default => 60
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "repeatable"
    t.string   "state",              :limit => 50,  :default => "", :null => false
    t.datetime "image_updated_at"
  end

  add_index "bosses", ["mission_group_id"], :name => "index_bosses_on_mission_group_id"

  create_table "character_titles", :force => true do |t|
    t.integer  "character_id", :null => false
    t.integer  "title_id",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "character_titles", ["character_id", "title_id"], :name => "index_character_titles_on_character_id_and_title_id", :unique => true

  create_table "character_types", :force => true do |t|
    t.string   "name",                  :limit => 100, :default => "",  :null => false
    t.text     "description"
    t.integer  "basic_money",                          :default => 10
    t.integer  "vip_money",                            :default => 0
    t.integer  "attack",                               :default => 1
    t.integer  "defence",                              :default => 1
    t.integer  "health",                               :default => 100
    t.integer  "energy",                               :default => 10
    t.string   "image_file_name",                      :default => "",  :null => false
    t.string   "image_content_type",    :limit => 100, :default => "",  :null => false
    t.integer  "image_file_size"
    t.string   "state",                 :limit => 50,  :default => "",  :null => false
    t.integer  "characters_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stamina",                              :default => 10
    t.integer  "health_restore_bonus",                 :default => 0
    t.integer  "energy_restore_bonus",                 :default => 0
    t.integer  "stamina_restore_bonus",                :default => 0
    t.integer  "income_period_bonus",                  :default => 0
    t.integer  "points",                               :default => 0
    t.integer  "equipment_slots",                      :default => 5
    t.datetime "image_updated_at"
  end

  create_table "characters", :force => true do |t|
    t.integer  "user_id",                                                                           :null => false
    t.string   "name",                     :limit => 100,        :default => ""
    t.integer  "basic_money"
    t.integer  "vip_money"
    t.integer  "level",                                          :default => 1
    t.integer  "experience",                                     :default => 0
    t.integer  "points"
    t.integer  "attack"
    t.integer  "defence"
    t.integer  "hp",                                             :default => 100
    t.integer  "health"
    t.integer  "ep",                                             :default => 10
    t.integer  "energy"
    t.text     "inventory_effects"
    t.datetime "hp_updated_at"
    t.datetime "ep_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "fights_won",                                     :default => 0
    t.integer  "fights_lost",                                    :default => 0
    t.integer  "missions_succeeded",                             :default => 0
    t.integer  "missions_completed",                             :default => 0
    t.integer  "relations_count",                                :default => 0
    t.integer  "bank",                     :limit => 8,          :default => 0
    t.datetime "basic_money_updated_at"
    t.text     "relation_effects"
    t.integer  "current_mission_group_id"
    t.integer  "character_type_id"
    t.integer  "stamina"
    t.integer  "sp",                                             :default => 10
    t.datetime "sp_updated_at"
    t.text     "placements",               :limit => 2147483647
    t.integer  "total_money",              :limit => 8,          :default => 0
    t.datetime "hospital_used_at",                               :default => '1970-01-01 05:00:00'
    t.integer  "missions_mastered",                              :default => 0
    t.integer  "lock_version",                                   :default => 0
    t.datetime "fighting_available_at",                          :default => '1970-01-01 05:00:00'
  end

  add_index "characters", ["level", "fighting_available_at"], :name => "by_level_and_fighting_time"
  add_index "characters", ["user_id"], :name => "index_characters_on_user_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.string   "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "facebook_templates", :force => true do |t|
    t.string "template_name", :null => false
    t.string "content_hash",  :null => false
    t.string "bundle_id"
  end

  add_index "facebook_templates", ["template_name"], :name => "index_facebook_templates_on_template_name", :unique => true

  create_table "fights", :force => true do |t|
    t.integer  "attacker_id",                                    :null => false
    t.integer  "victim_id",                                      :null => false
    t.integer  "winner_id"
    t.integer  "attacker_hp_loss"
    t.integer  "victim_hp_loss"
    t.integer  "experience"
    t.integer  "winner_money"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cause_id"
    t.string   "cause_type",       :limit => 50, :default => "", :null => false
    t.integer  "loser_money"
  end

  add_index "fights", ["attacker_id", "winner_id"], :name => "index_fights_on_attacker_id_and_winner_id"
  add_index "fights", ["cause_id"], :name => "index_fights_on_cause_id"
  add_index "fights", ["victim_id"], :name => "index_fights_on_victim_id"

  create_table "global_payouts", :force => true do |t|
    t.string   "name",       :limit => 100, :default => "", :null => false
    t.string   "alias",      :limit => 70,  :default => "", :null => false
    t.text     "payouts"
    t.string   "state",      :limit => 50,  :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "help_pages", :force => true do |t|
    t.string   "alias",             :limit => 100, :default => "", :null => false
    t.string   "name",              :limit => 100, :default => "", :null => false
    t.text     "content"
    t.text     "content_processed"
    t.string   "state",             :limit => 50,  :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "help_pages", ["alias"], :name => "index_help_pages_on_alias"

  create_table "hit_listings", :force => true do |t|
    t.integer  "client_id",                      :null => false
    t.integer  "victim_id",                      :null => false
    t.integer  "executor_id"
    t.integer  "reward"
    t.boolean  "completed",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hit_listings", ["client_id"], :name => "index_hit_listings_on_client_id"

  create_table "inventories", :force => true do |t|
    t.integer  "character_id",                                    :null => false
    t.integer  "item_id"
    t.integer  "usage_count",                      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "holder_id"
    t.string   "holder_type",        :limit => 50
    t.integer  "amount",                           :default => 0
    t.integer  "equipped",                         :default => 0
    t.integer  "market_items_count",               :default => 0
  end

  add_index "inventories", ["character_id"], :name => "index_inventories_on_character_id_and_placement"

  create_table "item_collection_ranks", :force => true do |t|
    t.integer  "character_id",                    :null => false
    t.integer  "collection_id",                   :null => false
    t.integer  "collection_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_collection_ranks", ["character_id", "collection_id"], :name => "index_collection_ranks_on_character_id_and_collection_id"

  create_table "item_collections", :force => true do |t|
    t.string   "name",       :limit => 100, :default => "", :null => false
    t.string   "item_ids",                  :default => "", :null => false
    t.text     "payouts"
    t.string   "state",      :limit => 50,  :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_groups", :force => true do |t|
    t.string   "name",            :limit => 100, :default => "",   :null => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "display_in_shop",                :default => true
    t.string   "state",           :limit => 50,  :default => "",   :null => false
  end

  create_table "item_sets", :force => true do |t|
    t.string   "name"
    t.string   "item_ids",   :limit => 2048
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.string   "availability",          :limit => 30,  :default => "shop", :null => false
    t.integer  "level"
    t.integer  "basic_price",           :limit => 8
    t.integer  "vip_price"
    t.string   "name",                  :limit => 100, :default => "",     :null => false
    t.string   "description",                          :default => "",     :null => false
    t.string   "placements",                           :default => "",     :null => false
    t.string   "image_file_name",                      :default => "",     :null => false
    t.string   "image_content_type",    :limit => 100, :default => "",     :null => false
    t.integer  "image_file_size"
    t.boolean  "usable"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_group_id",                                            :null => false
    t.boolean  "can_be_sold",                          :default => true
    t.integer  "attack",                               :default => 0
    t.integer  "defence",                              :default => 0
    t.integer  "owned",                                :default => 0
    t.integer  "limit"
    t.datetime "available_till"
    t.string   "plural_name",           :limit => 100, :default => "",     :null => false
    t.string   "state",                 :limit => 50,  :default => "",     :null => false
    t.boolean  "equippable",                           :default => false
    t.text     "payouts"
    t.string   "use_button_label",      :limit => 50,  :default => "",     :null => false
    t.string   "use_message",                          :default => "",     :null => false
    t.integer  "health"
    t.integer  "energy"
    t.integer  "stamina"
    t.boolean  "can_be_sold_on_market"
    t.datetime "image_updated_at"
    t.integer  "package_size"
    t.boolean  "boost"
  end

  add_index "items", ["item_group_id"], :name => "index_items_on_item_group_id"

  create_table "market_items", :force => true do |t|
    t.integer  "character_id", :null => false
    t.integer  "inventory_id", :null => false
    t.integer  "amount"
    t.integer  "basic_price"
    t.integer  "vip_price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "market_items", ["character_id"], :name => "index_market_items_on_character_id"

  create_table "mission_group_ranks", :force => true do |t|
    t.integer "character_id",     :null => false
    t.integer "mission_group_id", :null => false
    t.boolean "completed"
  end

  add_index "mission_group_ranks", ["character_id", "mission_group_id"], :name => "index_mission_group_ranks_on_character_id_and_mission_group_id"

  create_table "mission_groups", :force => true do |t|
    t.string   "name",               :limit => 100, :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "payouts"
    t.string   "image_file_name",                   :default => "", :null => false
    t.string   "image_content_type", :limit => 100, :default => "", :null => false
    t.integer  "image_file_size"
    t.string   "state",              :limit => 50,  :default => "", :null => false
    t.text     "requirements"
    t.boolean  "hide_unsatisfied"
    t.integer  "position"
    t.datetime "image_updated_at"
  end

  create_table "mission_help_results", :force => true do |t|
    t.integer  "character_id",                    :null => false
    t.integer  "requester_id",                    :null => false
    t.integer  "mission_id"
    t.integer  "basic_money"
    t.integer  "experience"
    t.boolean  "collected",    :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mission_help_results", ["character_id", "requester_id"], :name => "index_mission_help_results_on_character_id_and_requester_id"
  add_index "mission_help_results", ["requester_id", "collected"], :name => "index_mission_help_results_on_requester_id_and_collected"

  create_table "mission_level_ranks", :force => true do |t|
    t.integer  "character_id",                    :null => false
    t.integer  "mission_id",                      :null => false
    t.integer  "level_id",                        :null => false
    t.integer  "progress",     :default => 0
    t.boolean  "completed",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mission_level_ranks", ["character_id", "level_id"], :name => "index_mission_level_ranks_on_character_id_and_level_id", :unique => true
  add_index "mission_level_ranks", ["character_id", "mission_id"], :name => "index_mission_level_ranks_on_character_id_and_mission_id"

  create_table "mission_levels", :force => true do |t|
    t.integer  "mission_id",                  :null => false
    t.integer  "position"
    t.integer  "win_amount"
    t.integer  "chance",     :default => 100
    t.integer  "energy"
    t.integer  "experience"
    t.integer  "money_min"
    t.integer  "money_max"
    t.text     "payouts"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mission_levels", ["mission_id"], :name => "index_mission_levels_on_mission_id"

  create_table "mission_ranks", :force => true do |t|
    t.integer  "character_id",                        :null => false
    t.integer  "mission_id",                          :null => false
    t.boolean  "completed",        :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mission_group_id"
  end

  add_index "mission_ranks", ["character_id", "mission_id"], :name => "index_mission_ranks_on_character_id_and_mission_id", :unique => true

  create_table "missions", :force => true do |t|
    t.string   "name",                              :default => "",  :null => false
    t.text     "description"
    t.text     "success_text"
    t.text     "failure_text"
    t.text     "complete_text"
    t.integer  "win_amount"
    t.integer  "success_chance",                    :default => 100
    t.integer  "ep_cost"
    t.integer  "experience"
    t.integer  "money_min",          :limit => 8
    t.integer  "money_max",          :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "requirements"
    t.text     "payouts"
    t.integer  "mission_group_id",                                   :null => false
    t.string   "image_file_name",                   :default => "",  :null => false
    t.string   "image_content_type", :limit => 100, :default => "",  :null => false
    t.integer  "image_file_size"
    t.integer  "parent_mission_id"
    t.boolean  "repeatable"
    t.string   "state",              :limit => 50,  :default => "",  :null => false
    t.integer  "levels_count",                      :default => 0
    t.integer  "position"
    t.datetime "image_updated_at"
  end

  add_index "missions", ["mission_group_id"], :name => "index_missions_on_mission_group_id"

  create_table "monster_fights", :force => true do |t|
    t.integer  "character_id",                    :null => false
    t.integer  "monster_id",                      :null => false
    t.integer  "damage",           :default => 0
    t.boolean  "reward_collected"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "monster_fights", ["monster_id", "character_id"], :name => "index_monster_fights_on_monster_id_and_character_id"

  create_table "monster_types", :force => true do |t|
    t.integer  "level",                             :default => 1
    t.string   "name",               :limit => 100, :default => "", :null => false
    t.text     "description"
    t.integer  "health"
    t.integer  "attack"
    t.integer  "defence"
    t.integer  "minimum_damage"
    t.integer  "maximum_damage"
    t.integer  "minimum_response"
    t.integer  "maximum_response"
    t.integer  "experience"
    t.integer  "money"
    t.text     "requirements"
    t.text     "payouts"
    t.string   "image_file_name",                   :default => "", :null => false
    t.string   "image_content_type", :limit => 100, :default => "", :null => false
    t.integer  "image_file_size"
    t.integer  "fight_time",                        :default => 12
    t.string   "state",              :limit => 50,  :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "monsters", :force => true do |t|
    t.integer  "character_id",                                  :null => false
    t.integer  "monster_type_id",                               :null => false
    t.integer  "hp"
    t.string   "state",           :limit => 50, :default => "", :null => false
    t.datetime "expire_at"
    t.datetime "defeated_at"
    t.integer  "lock_version",                  :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", :force => true do |t|
    t.string   "type",         :limit => 100, :default => "", :null => false
    t.integer  "character_id",                                :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "news", ["character_id"], :name => "index_news_on_character_id"

  create_table "newsletters", :force => true do |t|
    t.string   "text"
    t.string   "state",             :limit => 50, :default => "", :null => false
    t.integer  "last_recipient_id"
    t.integer  "delivery_job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", :force => true do |t|
    t.string   "type",         :limit => 100, :default => "", :null => false
    t.integer  "character_id",                                :null => false
    t.string   "state",        :limit => 50,  :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "data"
  end

  add_index "notifications", ["character_id"], :name => "index_notifications_on_character_id"

  create_table "promotion_receipts", :force => true do |t|
    t.integer  "promotion_id", :null => false
    t.integer  "character_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "promotion_receipts", ["character_id", "promotion_id"], :name => "index_promotion_receipts_on_character_id_and_promotion_id"

  create_table "promotions", :force => true do |t|
    t.text     "text"
    t.text     "payouts"
    t.datetime "valid_till"
    t.integer  "promotion_receipts_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "forwardable"
  end

  create_table "properties", :force => true do |t|
    t.integer  "property_type_id",                :null => false
    t.integer  "character_id",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "level",            :default => 1
    t.datetime "collected_at"
  end

  add_index "properties", ["character_id"], :name => "index_properties_on_character_id"

  create_table "property_types", :force => true do |t|
    t.string   "name",                  :limit => 100, :default => "",     :null => false
    t.text     "description"
    t.string   "availability",          :limit => 30,  :default => "shop", :null => false
    t.integer  "level"
    t.integer  "basic_price",           :limit => 8
    t.integer  "vip_price"
    t.string   "image_file_name",                      :default => "",     :null => false
    t.string   "image_content_type",    :limit => 100, :default => "",     :null => false
    t.integer  "image_file_size"
    t.integer  "income"
    t.text     "requirements"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "upgrade_limit"
    t.integer  "upgrade_cost_increase"
    t.string   "plural_name",           :limit => 100, :default => "",     :null => false
    t.string   "state",                 :limit => 50,  :default => "",     :null => false
    t.integer  "collect_period",                       :default => 1
    t.text     "payouts"
    t.datetime "image_updated_at"
  end

  create_table "relations", :force => true do |t|
    t.integer  "owner_id",                                         :null => false
    t.integer  "character_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "inventory_effects"
    t.string   "type",              :limit => 50,  :default => "", :null => false
    t.string   "name",              :limit => 100, :default => "", :null => false
    t.integer  "level"
    t.integer  "attack"
    t.integer  "defence"
    t.integer  "health"
    t.integer  "energy"
    t.integer  "stamina"
  end

  add_index "relations", ["owner_id", "character_id"], :name => "index_relations_on_source_id_and_target_id"

  create_table "settings", :force => true do |t|
    t.string   "alias",      :limit => 100, :default => "", :null => false
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skins", :force => true do |t|
    t.string   "name",       :limit => 100, :default => "", :null => false
    t.text     "content"
    t.string   "state",      :limit => 50,  :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stories", :force => true do |t|
    t.string   "alias",              :limit => 70,  :default => "", :null => false
    t.string   "title",              :limit => 200, :default => "", :null => false
    t.string   "description",        :limit => 200, :default => "", :null => false
    t.string   "action_link",        :limit => 50,  :default => "", :null => false
    t.string   "payout_message",                    :default => "", :null => false
    t.string   "image_file_name",                   :default => "", :null => false
    t.string   "image_content_type", :limit => 100, :default => "", :null => false
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "payouts"
    t.string   "state",              :limit => 50,  :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "story_visits", :force => true do |t|
    t.integer  "character_id",                               :null => false
    t.integer  "story_id"
    t.string   "story_alias",  :limit => 70, :default => "", :null => false
    t.integer  "reference_id",                               :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tips", :force => true do |t|
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",      :limit => 50
  end

  create_table "titles", :force => true do |t|
    t.string   "name",       :limit => 100, :default => "", :null => false
    t.string   "state",      :limit => 50,  :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "translations", :force => true do |t|
    t.string   "key",        :default => "", :null => false
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "facebook_id",            :limit => 8,                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "show_fan_specials",                     :default => true
    t.boolean  "show_bookmark",                         :default => true
    t.boolean  "show_tips",                             :default => true
    t.string   "reference",              :limit => 100, :default => "",      :null => false
    t.boolean  "show_tutorial",                         :default => true
    t.integer  "referrer_id"
    t.string   "access_token",                          :default => "",      :null => false
    t.integer  "wall_privacy_level",                    :default => 2
    t.integer  "signup_ip",              :limit => 8
    t.integer  "last_visit_ip",          :limit => 8
    t.datetime "last_visit_at"
    t.string   "first_name",             :limit => 50,  :default => "",      :null => false
    t.string   "last_name",              :limit => 50,  :default => "",      :null => false
    t.integer  "gender"
    t.integer  "timezone"
    t.string   "locale",                 :limit => 5,   :default => "en_US", :null => false
    t.datetime "access_token_expire_at"
    t.string   "third_party_id",         :limit => 50,  :default => "",      :null => false
    t.text     "friend_ids"
    t.string   "email",                                 :default => "",      :null => false
  end

  add_index "users", ["facebook_id"], :name => "index_users_on_facebook_id"
  add_index "users", ["reference"], :name => "index_users_on_reference"

  create_table "vip_money_operations", :force => true do |t|
    t.string   "type",           :limit => 50,  :default => "", :null => false
    t.integer  "character_id",                                  :null => false
    t.integer  "amount"
    t.integer  "reference_id"
    t.string   "reference_type", :limit => 100, :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "visibilities", :force => true do |t|
    t.integer  "target_id",                                       :null => false
    t.string   "target_type",       :limit => 50, :default => "", :null => false
    t.integer  "character_type_id",                               :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "visibilities", ["target_id", "target_type"], :name => "index_visibilities_on_target_id_and_target_type"

  create_table "wall_posts", :force => true do |t|
    t.integer  "character_id", :null => false
    t.integer  "author_id",    :null => false
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wall_posts", ["character_id"], :name => "index_wall_posts_on_character_id"

end
