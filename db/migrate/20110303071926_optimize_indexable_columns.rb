class OptimizeIndexableColumns < ActiveRecord::Migration
  def self.up
    remove_index :mission_ranks, :name => :index_ranks_on_character_id_and_mission_id

    change_column :app_requests, :facebook_id, :bigint, :null => false
    change_column :assignments, :context_id, :integer, :null => false
    change_column :bank_operations, :character_id, :integer, :null => false
    change_column :character_titles, :character_id, :integer, :null => false
    change_column :character_titles, :title_id, :integer, :null => false
    change_column :characters, :user_id, :integer, :null => false
    change_column :fights, :attacker_id, :integer, :null => false
    change_column :fights, :victim_id, :integer, :null => false
    change_column :gifts, :receiver_id, :bigint, :null => false
    change_column :gifts, :sender_id, :integer, :null => false
    change_column :hit_listings, :client_id, :integer, :null => false
    change_column :hit_listings, :victim_id, :integer, :null => false
    change_column :inventories, :character_id, :integer, :null => false
    change_column :invitations, :sender_id, :integer, :null => false
    change_column :invitations, :receiver_id, :bigint, :null => false
    change_column :item_collection_ranks, :character_id, :integer, :null => false
    change_column :item_collection_ranks, :collection_id, :integer, :null => false
    change_column :items, :item_group_id, :integer, :null => false
    change_column :market_items, :character_id, :integer, :null => false
    change_column :market_items, :inventory_id, :integer, :null => false
    change_column :mission_group_ranks, :character_id, :integer, :null => false
    change_column :mission_group_ranks, :mission_group_id, :integer, :null => false
    change_column :mission_help_results, :character_id, :integer, :null => false
    change_column :mission_help_results, :requester_id, :integer, :null => false
    change_column :mission_level_ranks, :character_id, :integer, :null => false
    change_column :mission_level_ranks, :mission_id, :integer, :null => false
    change_column :mission_level_ranks, :level_id, :integer, :null => false
    change_column :mission_levels, :mission_id, :integer, :null => false
    change_column :mission_ranks, :character_id, :integer, :null => false
    change_column :mission_ranks, :mission_id, :integer, :null => false
    change_column :missions, :mission_group_id, :integer, :null => false
    change_column :monster_fights, :character_id, :integer, :null => false
    change_column :monster_fights, :monster_id, :integer, :null => false
    change_column :monsters, :character_id, :integer, :null => false
    change_column :monsters, :monster_type_id, :integer, :null => false
    change_column :news, :character_id, :integer, :null => false
    change_column :notifications, :character_id, :integer, :null => false
    change_column :promotion_receipts, :character_id, :integer, :null => false
    change_column :promotion_receipts, :promotion_id, :integer, :null => false
    change_column :properties, :character_id, :integer, :null => false
    change_column :properties, :property_type_id, :integer, :null => false
    change_column :relations, :owner_id, :integer, :null => false
    change_column :story_visits, :character_id, :integer, :null => false
    change_column :story_visits, :reference_id, :integer, :null => false
    change_column :users, :facebook_id, :bigint, :null => false
    change_column :vip_money_operations, :character_id, :integer, :null => false
    change_column :visibilities, :character_type_id, :integer, :null => false
    change_column :visibilities, :target_id, :integer, :null => false
    change_column :wall_posts, :character_id, :integer, :null => false
    change_column :wall_posts, :author_id, :integer, :null => false

    add_index :app_requests, :facebook_id
    add_index :monster_fights, [:monster_id, :character_id]
    add_index :story_visits, [:character_id, :story_alias, :reference_id]
    add_index :wall_posts, :character_id
  end

  def self.down
    remove_index :app_requests,   :column => :facebook_id
    remove_index :monster_fights, :column => [:monster_id, :character_id]
    remove_index :story_visits,   :column => [:character_id, :story_alias, :reference_id]
    remove_index :wall_posts,     :column => :character_id

    change_column :app_requests, :facebook_id, :bigint, :null => true
    change_column :assignments, :context_id, :integer, :null => true
    change_column :bank_operations, :character_id, :integer, :null => true
    change_column :character_titles, :character_id, :integer, :null => true
    change_column :character_titles, :title_id, :integer, :null => true
    change_column :characters, :user_id, :integer, :null => true
    change_column :fights, :attacker_id, :integer, :null => true
    change_column :fights, :victim_id, :integer, :null => true
    change_column :gifts, :receiver_id, :bigint, :null => true
    change_column :gifts, :sender_id, :integer, :null => true
    change_column :hit_listings, :client_id, :integer, :null => true
    change_column :hit_listings, :victim_id, :integer, :null => true
    change_column :inventories, :character_id, :integer, :null => true
    change_column :invitations, :sender_id, :integer, :null => true
    change_column :invitations, :receiver_id, :bigint, :null => true
    change_column :item_collection_ranks, :character_id, :integer, :null => true
    change_column :item_collection_ranks, :collection_id, :integer, :null => true
    change_column :items, :item_group_id, :integer, :null => true
    change_column :market_items, :character_id, :integer, :null => true
    change_column :market_items, :inventory_id, :integer, :null => true
    change_column :mission_group_ranks, :character_id, :integer, :null => true
    change_column :mission_group_ranks, :mission_group_id, :integer, :null => true
    change_column :mission_help_results, :character_id, :integer, :null => true
    change_column :mission_help_results, :requester_id, :integer, :null => true
    change_column :mission_level_ranks, :character_id, :integer, :null => true
    change_column :mission_level_ranks, :mission_id, :integer, :null => true
    change_column :mission_level_ranks, :level_id, :integer, :null => true
    change_column :mission_levels, :mission_id, :integer, :null => true
    change_column :mission_ranks, :character_id, :integer, :null => true
    change_column :mission_ranks, :mission_id, :integer, :null => true
    change_column :missions, :mission_group_id, :integer, :null => true
    change_column :monster_fights, :character_id, :integer, :null => true
    change_column :monster_fights, :monster_id, :integer, :null => true
    change_column :monsters, :character_id, :integer, :null => true
    change_column :monsters, :monster_type_id, :integer, :null => true
    change_column :news, :character_id, :integer, :null => true
    change_column :notifications, :character_id, :integer, :null => true
    change_column :promotion_receipts, :character_id, :integer, :null => true
    change_column :promotion_receipts, :promotion_id, :integer, :null => true
    change_column :properties, :character_id, :integer, :null => true
    change_column :properties, :property_type_id, :integer, :null => true
    change_column :relations, :owner_id, :integer, :null => true
    change_column :story_visits, :character_id, :integer, :null => true
    change_column :story_visits, :reference_id, :integer, :null => true
    change_column :users, :facebook_id, :bigint, :null => true
    change_column :vip_money_operations, :character_id, :integer, :null => true
    change_column :visibilities, :character_type_id, :integer, :null => true
    change_column :visibilities, :target_id, :integer, :null => true
    change_column :wall_posts, :character_id, :integer, :null => true
    change_column :wall_posts, :author_id, :integer, :null => true
  end
end
