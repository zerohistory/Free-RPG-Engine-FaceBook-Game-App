class MakeStringColumnsNonNull < ActiveRecord::Migration
  def self.up
    change_column :assets, :alias,                        :string, :limit => 200, :null => false, :default => ''
    change_column :assets, :image_file_name,              :string, :limit => 255, :null => false, :default => ''
    change_column :assets, :image_content_type,           :string, :limit => 100, :null => false, :default => ''

    change_column :assignments, :context_type,            :string, :limit => 50,  :null => false, :default => ''
    change_column :assignments, :role,                    :string, :limit => 50,  :null => false, :default => ''

    change_column :bank_operations, :type,                :string, :limit => 50,  :null => false, :default => ''

    change_column :boosts, :name,                         :string, :limit => 100, :null => false, :default => ''
    change_column :boosts, :description,                  :string, :limit => 255, :null => false, :default => ''
    change_column :boosts, :image_file_name,              :string, :limit => 255, :null => false, :default => ''
    change_column :boosts, :image_content_type,           :string, :limit => 100, :null => false, :default => ''
    change_column :boosts, :state,                        :string, :limit => 50,  :null => false, :default => ''

    change_column :boss_fights, :state,                   :string, :limit => 50,  :null => false, :default => ''

    change_column :bosses, :name,                         :string, :limit => 100, :null => false, :default => ''
    change_column :bosses, :image_file_name,              :string, :limit => 255, :null => false, :default => ''
    change_column :bosses, :image_content_type,           :string, :limit => 100, :null => false, :default => ''
    change_column :bosses, :state,                        :string, :limit => 50,  :null => false, :default => ''

    change_column :character_types, :name,                :string, :limit => 100, :null => false, :default => ''
    change_column :character_types, :image_file_name,     :string, :limit => 255, :null => false, :default => ''
    change_column :character_types, :image_content_type,  :string, :limit => 100, :null => false, :default => ''
    change_column :character_types, :state,               :string, :limit => 50,  :null => false, :default => ''

    change_column :characters, :name,                     :string, :limit => 100, :null => false, :default => ''

    change_column :fights, :cause_type,                   :string, :limit => 50,  :null => false, :default => ''

    change_column :help_pages, :alias,                    :string, :limit => 100, :null => false, :default => ''
    change_column :help_pages, :name,                     :string, :limit => 100, :null => false, :default => ''
    change_column :help_pages, :state,                    :string, :limit => 50,  :null => false, :default => ''

    change_column :help_requests, :context_type,          :string, :limit => 50,  :null => false, :default => ''

    change_column :item_collections, :name,               :string, :limit => 100, :null => false, :default => ''
    change_column :item_collections, :item_ids,           :string, :limit => 255, :null => false, :default => ''
    change_column :item_collections, :state,              :string, :limit => 50,  :null => false, :default => ''

    change_column :item_groups, :name,                    :string, :limit => 100, :null => false, :default => ''
    change_column :item_groups, :state,                   :string, :limit => 50,  :null => false, :default => ''

    change_column :items, :availability,                  :string, :limit => 30,  :null => false, :default => 'shop'
    change_column :items, :name,                          :string, :limit => 100, :null => false, :default => ''
    change_column :items, :description,                   :string, :limit => 255, :null => false, :default => ''
    change_column :items, :placements,                    :string, :limit => 255, :null => false, :default => ''
    change_column :items, :image_file_name,               :string, :limit => 255, :null => false, :default => ''
    change_column :items, :image_content_type,            :string, :limit => 100, :null => false, :default => ''
    change_column :items, :plural_name,                   :string, :limit => 100, :null => false, :default => ''
    change_column :items, :state,                         :string, :limit => 50,  :null => false, :default => ''
    change_column :items, :use_button_label,              :string, :limit => 50,  :null => false, :default => ''
    change_column :items, :use_message,                   :string, :limit => 255, :null => false, :default => ''

    change_column :mission_groups, :name,                 :string, :limit => 100, :null => false, :default => ''
    change_column :mission_groups, :image_file_name,      :string, :limit => 255, :null => false, :default => ''
    change_column :mission_groups, :image_content_type,   :string, :limit => 100, :null => false, :default => ''
    change_column :mission_groups, :state,                :string, :limit => 50,  :null => false, :default => ''

    change_column :missions, :name,                       :string, :limit => 255, :null => false, :default => ''
    change_column :missions, :image_file_name,            :string, :limit => 255, :null => false, :default => ''
    change_column :missions, :image_content_type,         :string, :limit => 100, :null => false, :default => ''
    change_column :missions, :loot_item_ids,              :string, :limit => 255, :null => false, :default => ''
    change_column :missions, :state,                      :string, :limit => 50,  :null => false, :default => ''

    change_column :news, :type,                           :string, :limit => 100, :null => false, :default => ''

    change_column :newsletters, :state,                   :string, :limit => 50,  :null => false, :default => ''

    change_column :notifications, :type,                  :string, :limit => 100, :null => false, :default => ''
    change_column :notifications, :state,                 :string, :limit => 50,  :null => false, :default => ''

    change_column :property_types, :name,                 :string, :limit => 100, :null => false, :default => ''
    change_column :property_types, :availability,         :string, :limit => 30,  :null => false, :default => 'shop'
    change_column :property_types, :image_file_name,      :string, :limit => 255, :null => false, :default => ''
    change_column :property_types, :image_content_type,   :string, :limit => 100, :null => false, :default => ''
    change_column :property_types, :plural_name,          :string, :limit => 100, :null => false, :default => ''
    change_column :property_types, :state,                :string, :limit => 50,  :null => false, :default => ''

    change_column :relations, :type,                      :string, :limit => 50,  :null => false, :default => ''
    change_column :relations, :name,                      :string, :limit => 100, :null => false, :default => ''

    change_column :settings, :alias,                      :string, :limit => 100, :null => false, :default => ''

    change_column :skins, :name,                          :string, :limit => 100, :null => false, :default => ''
    change_column :skins, :state,                         :string, :limit => 50,  :null => false, :default => ''

    change_column :titles, :name,                         :string, :limit => 100, :null => false, :default => ''
    change_column :titles, :state,                        :string, :limit => 50,  :null => false, :default => ''

    change_column :translations, :key,                    :string, :limit => 255, :null => false, :default => ''

    change_column :users, :reference,                     :string, :limit => 100, :null => false, :default => ''
    change_column :users, :last_landing,                  :string, :limit => 100, :null => false, :default => ''

    change_column :vip_money_operations, :type,           :string, :limit => 50,  :null => false, :default => ''
    change_column :vip_money_operations, :reference_type, :string, :limit => 100, :null => false, :default => ''

    change_column :visibilities, :target_type,            :string, :limit => 50,  :null => false, :default => ''
  end

  def self.down
    change_column :assets, :alias,                        :string, :limit => 255, :null => true, :default => nil
    change_column :assets, :image_file_name,              :string, :limit => 255, :null => true, :default => nil
    change_column :assets, :image_content_type,           :string, :limit => 255, :null => true, :default => nil

    change_column :assignments, :context_type,            :string, :limit => 255, :null => true, :default => nil
    change_column :assignments, :role,                    :string, :limit => 255, :null => true, :default => nil

    change_column :bank_operations, :type,                :string, :limit => 255, :null => true, :default => nil

    change_column :boosts, :name,                         :string, :limit => 255, :null => true, :default => nil
    change_column :boosts, :description,                  :string, :limit => 255, :null => true, :default => nil
    change_column :boosts, :image_file_name,              :string, :limit => 255, :null => true, :default => nil
    change_column :boosts, :image_content_type,           :string, :limit => 255, :null => true, :default => nil
    change_column :boosts, :state,                        :string, :limit => 30,  :null => true, :default => nil

    change_column :boss_fights, :state,                   :string, :limit => 50,  :null => true, :default => nil

    change_column :bosses, :name,                         :string, :limit => 255, :null => true, :default => nil
    change_column :bosses, :image_file_name,              :string, :limit => 255, :null => true, :default => nil
    change_column :bosses, :image_content_type,           :string, :limit => 255, :null => true, :default => nil
    change_column :bosses, :state,                        :string, :limit => 30,  :null => true, :default => nil

    change_column :character_types, :name,                :string, :limit => 100, :null => true, :default => nil
    change_column :character_types, :image_file_name,     :string, :limit => 255, :null => true, :default => nil
    change_column :character_types, :image_content_type,  :string, :limit => 255, :null => true, :default => nil
    change_column :character_types, :state,               :string, :limit => 30,  :null => true, :default => nil

    change_column :characters, :name,                     :string, :limit => 255, :null => true, :default => nil

    change_column :fights, :cause_type,                   :string, :limit => 30,  :null => true, :default => nil

    change_column :help_pages, :alias,                    :string, :limit => 100, :null => true, :default => nil
    change_column :help_pages, :name,                     :string, :limit => 100, :null => true, :default => nil
    change_column :help_pages, :state,                    :string, :limit => 30,  :null => true, :default => nil

    change_column :help_requests, :context_type,          :string, :limit => 30,  :null => true, :default => nil

    change_column :item_collections, :name,               :string, :limit => 255, :null => true, :default => nil
    change_column :item_collections, :item_ids,           :string, :limit => 255, :null => true, :default => nil
    change_column :item_collections, :state,              :string, :limit => 30,  :null => true, :default => nil

    change_column :item_groups, :name,                    :string, :limit => 255, :null => true, :default => nil
    change_column :item_groups, :state,                   :string, :limit => 30,  :null => true, :default => nil

    change_column :items, :availability,                  :string, :limit => 30,  :null => true, :default => 'shop'
    change_column :items, :name,                          :string, :limit => 255, :null => true, :default => nil
    change_column :items, :description,                   :string, :limit => 255, :null => true, :default => nil
    change_column :items, :placements,                    :string, :limit => 255, :null => true, :default => nil
    change_column :items, :image_file_name,               :string, :limit => 255, :null => true, :default => nil
    change_column :items, :image_content_type,            :string, :limit => 255, :null => true, :default => nil
    change_column :items, :plural_name,                   :string, :limit => 255, :null => true, :default => nil
    change_column :items, :state,                         :string, :limit => 30,  :null => true, :default => nil
    change_column :items, :use_button_label,              :string, :limit => 255, :null => true, :default => nil
    change_column :items, :use_message,                   :string, :limit => 255, :null => true, :default => nil

    change_column :mission_groups, :name,                 :string, :limit => 255, :null => true, :default => nil
    change_column :mission_groups, :image_file_name,      :string, :limit => 255, :null => true, :default => nil
    change_column :mission_groups, :image_content_type,   :string, :limit => 255, :null => true, :default => nil
    change_column :mission_groups, :state,                :string, :limit => 30,  :null => true, :default => nil

    change_column :missions, :name,                       :string, :limit => 255, :null => true, :default => nil
    change_column :missions, :image_file_name,            :string, :limit => 255, :null => true, :default => nil
    change_column :missions, :image_content_type,         :string, :limit => 255, :null => true, :default => nil
    change_column :missions, :loot_item_ids,              :string, :limit => 255, :null => true, :default => nil
    change_column :missions, :state,                      :string, :limit => 30,  :null => true, :default => nil

    change_column :news, :type,                           :string, :limit => 100, :null => true, :default => nil

    change_column :newsletters, :state,                   :string, :limit => 20,  :null => true, :default => nil

    change_column :notifications, :type,                  :string, :limit => 100, :null => true, :default => nil
    change_column :notifications, :state,                 :string, :limit => 50,  :null => true, :default => nil

    change_column :property_types, :name,                 :string, :limit => 255, :null => true, :default => nil
    change_column :property_types, :availability,         :string, :limit => 30,  :null => true, :default => 'shop'
    change_column :property_types, :image_file_name,      :string, :limit => 255, :null => true, :default => nil
    change_column :property_types, :image_content_type,   :string, :limit => 255, :null => true, :default => nil
    change_column :property_types, :plural_name,          :string, :limit => 255, :null => true, :default => nil
    change_column :property_types, :state,                :string, :limit => 30,  :null => true, :default => nil

    change_column :relations, :type,                      :string, :limit => 255, :null => true, :default => nil
    change_column :relations, :name,                      :string, :limit => 255, :null => true, :default => nil

    change_column :settings, :alias,                      :string, :limit => 255, :null => true, :default => nil

    change_column :skins, :name,                          :string, :limit => 255, :null => true, :default => nil
    change_column :skins, :state,                         :string, :limit => 255, :null => true, :default => nil

    change_column :titles, :name,                         :string, :limit => 255, :null => true, :default => nil
    change_column :titles, :state,                        :string, :limit => 50,  :null => true, :default => nil

    change_column :translations, :key,                    :string, :limit => 255, :null => true, :default => nil

    change_column :users, :reference,                     :string, :limit => 255, :null => true, :default => nil
    change_column :users, :last_landing,                  :string, :limit => 255, :null => true, :default => nil

    change_column :vip_money_operations, :type,           :string, :limit => 100, :null => true, :default => nil
    change_column :vip_money_operations, :reference_type, :string, :limit => 100, :null => true, :default => nil

    change_column :visibilities, :target_type,            :string, :limit => 255, :null => true, :default => nil
  end
end
