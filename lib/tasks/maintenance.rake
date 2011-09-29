namespace :app do
  namespace :maintenance do
    desc "Update translation keys"
    task :update_translations => :environment do
      puts "Updating interpolation keys..."
      
      Translation.find_each do |translation|
        translation.value_will_change!
        translation.value.gsub!(/\{\{([^}]+)\}\}/im, '%{\1}')
        
        translation.save!
      end

      puts "Updating translation keys..."

      {
        "characters.level_up.title"             => "notifications.level_up.title",
        "characters.level_up.text"              => "notifications.level_up.text",
        "characters.level_up.upgrade_link"      => "notifications.level_up.upgrade_link",
        "characters.level_up.buttons.continue"  => "notifications.level_up.buttons.continue",
        "characters.level_up.buttons.upgrade"   => "notifications.level_up.buttons.upgrade",

        "mission_groups.tabs.level"             => nil,
        "mission_groups.tabs.previous.name"     => "mission_groups.tabs.previous",
        "mission_groups.tabs.previous.level"    => nil,
        "mission_groups.tabs.next.name"         => "mission_groups.tabs.next",
        "mission_groups.tabs.next.level"        => nil,
        "mission_groups.show.locked_group"      => nil,
        "relations.index.members.title"         => "relations.members.title",
        
        'stories.help_request.fight.title'            => nil,
        'stories.help_request.action_link'            => nil,
        'stories.help_request.mission.title'          => ['stories.mission_help.title', {:mission => :name}],
        'stories.help_request.mission.description'    => 'stories.mission_help.description',
        'stories.inventory.title'                     => ['stories.item_purchased.title', {:item => :name}],
        'stories.mission.title'                       => ['stories.mission_completed.title', {:mission => :name}],
        'stories.boss.title'                          => ['stories.boss_defeated.title', {:boss => :name}],
        'stories.monster_invite.title'                => {:monster => :name},
        'stories.monster_invite.description'          => {:monster => :name},
        'stories.monster_defeated.title'              => {:monster => :name},
        'stories.property.title'                      => {:property => :name},
        'stories.collection.completed.title'          => ['stories.collection_completed.title', {:collection => :name}],
        'stories.collection.missing_items.title'        => ['stories.collection_missing_items.title', {:collection => :name}],
        'stories.collection.missing_items.description'  => ['stories.collection_missing_items.description', {:collection => :name}],
        'stories.hitlist.new_listing.title'             => 'stories.hit_listing_new.title',
        'stories.hitlist.new_listing.description'       => 'stories.hit_listing_new.description',
        'stories.hitlist.new_listing.action_link'       => 'stories.hit_listing_new.action_link',
        'stories.hitlist.completed_listing.title'       => 'stories.hit_listing_completed.title',
        'stories.hitlist.completed_listing.description' => 'stories.hit_listing_completed.description',
        'stories.hitlist.completed_listing.action_link' => 'stories.hit_listing_completed.action_link'
      }.each do |old_key, update|
        if translation = Translation.find_by_key(old_key)
          print "#{old_key} - "

          if update.nil?
            translation.destroy

            puts "Deleted"
          elsif update.is_a?(String)
            translation.update_attribute(:key, update)

            puts "Updated"
          elsif update.is_a?(Hash)
            translation.update_interpolation_keys(update)
          elsif update.is_a?(Array)
            translation.update_attribute(:key, update.first)
            translation.update_interpolation_keys(update.last)
          end
        end
      end
      
      puts "Done!"
    end

    desc "Update image thumbnails"
    task :update_thumbnails => :environment do
      [Boss, MonsterType, CharacterType, Item, Mission, MissionGroup, PropertyType].each do |klass|
        scope = klass.without_state(:deleted)

        puts "Updating thumbails for #{scope.count} of #{klass}..."

        i = 0

        scope.all.each do |object|
          object.image.reprocess! if object.image?

          i += 1

          puts "Processed #{i} of #{scope.count}..." if i % 10 == 0
        end
      end
      
      puts "Done!"
    end

    # One-time tasks
    
    desc 'Unify application requests into a single table'
    task :unify_requests => :environment do
      puts "Updating request types..."
      
      AppRequest::Base.transaction do
        AppRequest::Base.delete_all ["created_at <= ?", 2.weeks.ago]
        
        AppRequest::Base.update_all "state='accepted'", "state='accepted_indirectly'"

        AppRequest::Base.update_all "type = 'AppRequest::Gift'", "data LIKE '%type: gift%'"
        AppRequest::Base.update_all "type = 'AppRequest::MonsterInvite'", "data LIKE '%type: monster%'"
        AppRequest::Base.update_all "type = 'AppRequest::Invitation'", "data LIKE '%type: invitation%'"
        AppRequest::Base.delete_all 'data IS NULL'
      end
      
      puts "Updating sender IDs for #{AppRequest::Base.count} requests..."
      
      i = 0
      
      AppRequest::Base.transaction do
        AppRequest::Base.find_each do |request|
          request.update_attribute(:sender_id, Character.find_by_user_id(request.sender_id).id)
          
          i += 1
          
          puts "Processed #{i}..." if i % 100 == 0
        end
      end
      
      monster_invites = AppRequest::MonsterInvite.with_state(:processed)
      
      puts "Processing #{monster_invites.size} monster invites..."
      
      AppRequest::MonsterInvite.transaction do
        i = 0
        
        monster_invites.find_each do |request|
          request.data['monster_id'] = request.data['return_to'].match(/\/monsters\/([0-9]+)/)[1]
          request.save
          
          i += 1
          
          puts "Processed #{i}..." if i % 100 == 0
        end
      end
      
      puts 'Updating requests for accepted gifts...'
      
      ids = ActiveRecord::Base.connection.select_values("SELECT DISTINCT app_request_id FROM gifts WHERE gifts.state = 'accepted'")
      
      puts "Update #{ids.size} requests..."
      
      i = 0
      
      ids.each do |id|
        AppRequest::Base.update_all "state = 'accepted'", {:id => id}
        
        i += 1
        
        puts "Processed #{i}..." if i % 100 == 0
      end
      
      puts 'Done!'
    end
    

    desc 'Convert payout triggers'
    task :convert_loot_to_random_payout => :environment do
      puts 'Converting mission loot to payouts...'

      Mission.without_state(:deleted).all.each do |mission|
        if mission.loot_item_ids.present?
          set = ItemSet.create!(
            :name => "Item Set for Mission '#{mission.name}'",
            :items => Item.find_all_by_id(mission.loot_item_ids.split(',')).collect{|i| [i, 10] }
          )

          mission.payouts = Payouts::Collection.new(
            Payouts::RandomItem.new(
              :apply_on     => [:success, :repeat_success, :level_complete],
              :action       => :add,
              :item_set_id  => set.id,
              :chance       => mission.loot_chance
            )
          )
        else
          mission.payouts = nil
        end

        mission.save!
      end

      puts 'Converting mission level payout triggers...'

      MissionLevel.all.each do |level|
        level.payouts.each do |payout|
          payout.apply_on.collect!{|a| a == :complete ? :level_complete : a }
        end

        level.save!
      end

      puts 'Converting mission group payout trigers...'

      MissionGroup.all.each do |group|
        group.payouts.each do |payout|
          payout.apply_on.collect!{|a| a == :complete ? :mission_group_complete : a }
        end

        group.save!
      end

      puts 'Done!'
    end

    desc 'Convert random item payouts to item sets'
    task :convert_random_item_payouts_to_sets => :environment do
      puts 'Converting random item payouts to item sets...'

      i = 0

      ActiveRecord::Base.transaction do
        [Boss, Item, ItemCollection, Mission, MissionGroup, MissionLevel, Promotion, PropertyType, MonsterType].each do |klass|
          klass.find_each do |record|
            record.payouts.each do |payout|
              if payout.is_a?(Payouts::RandomItem) and item_ids = payout.instance_variable_get(:@item_ids) and !item_ids.empty?
                payout.send(:remove_instance_variable, :@item_ids)
                
                item_set = ItemSet.create!(
                  :name   => "Item Set #{i}",
                  :items  => Item.find_all_by_id(item_ids).collect{|item| [item, 10] }
                )

                payout.item_set_id = item_set.id

                i += 1
              end
            end

            record.save
          end
        end
      end

      puts "Done! #{i} payouts converted"
    end

    desc 'Convert boosts to items'
    task :convert_boosts_to_items => :environment do
      puts 'Converting boosts to items...'

      puts 'Removing news related to boosts...'

      News::Base.delete_all "type = 'News::BoostPurchase'"

      puts 'Converting boosts...'

      group = ItemGroup.find_or_create_by_name('Boosts')

      ids = {}
      
      ActiveRecord::Base.transaction do
        ActiveRecord::Base.connection.execute('SELECT * FROM boosts').each do |boost|
          image_path = Rails.root.join('public', 'system', 'boosts', ("%09d" % boost[0].to_i).scan(/\d{3}/).join("/"), 'original', boost[9])

          item = group.items.create!(
            :name         => boost[1],
            :description  => boost[2],
            :level        => boost[3],
            :attack       => boost[4],
            :defence      => boost[5],
            :health       => boost[6],
            :basic_price  => boost[7],
            :vip_price    => boost[8],
            :image        => (boost[9].present? && File.file?(image_path) ? File.open(image_path) : ''),
            :boost => true
          )

          ids[boost[0].to_i] = item.id

          ActiveRecord::Base.connection.execute("SELECT * FROM purchased_boosts WHERE boost_id = #{boost[0]}").each do |purchased|
            Character.find(purchased[1]).inventories.give!(item)
          end
        end
      end

      puts 'Converting payouts...'

      [Boss, Item, ItemCollection, Mission, MissionGroup, MissionLevel, Promotion, PropertyType].each do |klass|
        klass.find_each do |record|
          if record.payouts.any? and record.payouts.detect{|p| p.class == 'Payouts::Boost'}
            new_collection = Payouts::Collection.new

            record.payouts.each do |payout|
              if payout.class == 'Payouts::Boost'
                new_collection << Payouts::Item.new(payout.ivars.symbolize_keys.merge(:value => ids[payout.ivars['value']]))
              else
                new_collection << payout
              end
            end

            record.payouts = new_collection
            record.save!
          end
        end
      end

      puts 'Done!'
    end

    desc "Set default positions to missions within mission groups"
    task :enumerate_missions => :environment do
      total = Mission.without_state(:deleted).count
      
      puts "Enumerating #{total} missions..."

      MissionGroup.without_state(:deleted).find_each do |group|
        position = 1

        group.missions.without_state(:deleted).each do |mission|
          mission.update_attribute(:position, position)

          position += 1
        end
      end

      puts "Done!"
    end

    desc "Remove duplicate character titles"
    task :remove_duplicate_character_titles => :environment do
      puts "Removing duplicate level ranks..."

      i = 0

      CharacterTitle.all(
        :select => "character_id, title_id, COUNT(title_id) as title_count",
        :group => "character_id, title_id HAVING title_count > 1"
      ).each do |title|
        character_titles = CharacterTitle.all(:conditions => {:character_id => title.character_id, :title_id => title.title_id})

        # Removing first from the list
        character_titles.shift

        CharacterTitle.transaction do
          character_titles.each do |duplicate|
            duplicate.destroy

            i += 1
          end
        end
      end

      puts "Done! #{i} duplicates removed"
    end

    desc "Remove duplicate mission and mission level ranks"
    task :remove_duplicate_ranks => :environment do
      puts "Removing duplicate level ranks..."

      i = 0
      
      MissionLevelRank.all(
        :select => "character_id, level_id, COUNT(level_id) as level_count",
        :group => "character_id, level_id HAVING level_count > 1"
      ).each do |rank|
        level_ranks = MissionLevelRank.all(:conditions => {:character_id => rank.character_id, :level_id => rank.level_id})

        rank_to_keep = level_ranks.max_by(&:progress)
        
        level_ranks.delete(rank_to_keep)

        MissionLevelRank.transaction do
          level_ranks.each do |duplicate|
            rank_to_keep.progress += duplicate.progress

            duplicate.destroy

            i += 1
          end

          rank_to_keep.save
        end
      end

      puts "Done! #{i} duplicates removed"

      puts "Removing duplicate mission ranks..."

      i = 0
      
      MissionRank.all(
        :select => "character_id, mission_id, COUNT(mission_id) as mission_count",
        :group => "character_id, mission_id HAVING mission_count > 1"
      ).each do |rank|
        mission_ranks = MissionRank.all(:conditions => {:character_id => rank.character_id, :mission_id => rank.mission_id})
        mission_ranks.delete(mission_ranks.detect{|r| r.completed } || mission_ranks.first)

        mission_ranks.each do |duplicate|
          duplicate.destroy

          i += 1
        end
      end

      puts "Done! #{i} duplicates removed"
    end

    desc "Recalculate mission stats for characters"
    task :recalculate_mission_stats => :environment do
      total = Character.count

      puts "Recalculating mission stats for #{total} characters..."

      i = 0

      Character.find_each(:batch_size => 1) do |character|
        character.missions_succeeded = character.mission_level_ranks.sum(:progress)
        character.missions_completed = character.mission_level_ranks.scoped(:conditions => {:completed => true}).count
        character.missions_mastered = character.mission_ranks.scoped(:conditions => {:completed => true}).count

        character.save

        i += 1

        puts "Processed #{i} of #{total}..." if i % 100 == 0
      end

      puts "Done!"
    end

    desc "Update missions mastered count for characters"
    task :update_missions_mastered_count => :environment do
      puts "Updating mastered missions counter..."

      last_level_ids = Mission.all(:include => :levels).collect{|m| m.levels.last.id }

      Character.update_all(
        [
          %{
            missions_mastered = (
              SELECT count(*)
              FROM mission_level_ranks
              WHERE
                character_id = characters.id AND
                level_id IN (?) AND
                completed = 1
            )
          },
          last_level_ids
        ]
      )

      puts "Done!"
    end

    desc "Convert mission group levels to requirements"
    task :convert_mission_group_levels_to_requirements => :environment do
      puts "Converting mission group levels to requirements (#{MissionGroup.count} groups)..."

      MissionGroup.find_each do |group|
        requirement = Requirements::Level.new(:value => group.level)

        if group.requirements.any?
          group.requirements.unshift(requirement)
        else
          group.requirements = Requirements::Collection.new(
            requirement
          )
        end

        group.save!
      end

      puts "Done!"
    end

    desc "Add positions to mission groups"
    task :add_positions_to_mission_groups => :environment do
      puts "Adding positions to mission groups (#{MissionGroup.without_state(:deleted).count} groups)..."

      position = 1

      MissionGroup.without_state(:deleted).all(:order => "level").each do |group|
        group.update_attribute(:position, position)

        position += 1
      end

      puts "Done!"
    end

    desc "Move mission attributes to mission levels"
    task :move_mission_attributes_to_levels => :environment do
      puts "Moving mission attributes to mastery levels (#{Mission.count} missions)..."

      Mission.find_each do |mission|
        next if mission.levels.any?

        mission.levels.create!(
          :win_amount => mission.win_amount,
          :chance     => mission.success_chance,
          :energy     => mission.ep_cost,
          :experience => mission.experience,
          :money_min  => mission.money_min,
          :money_max  => mission.money_max,
          :payouts    => mission.payouts
        )
      end

      puts "Upgrading mission ranks to mission level ranks (#{MissionRank.count} records)..."

      i = 0

      MissionRank.find_each(:include => :mission, :batch_size => 100) do |rank|
        MissionLevelRank.create!(
          :level      => rank.mission.levels.first,
          :character  => rank.character,
          :progress   => rank.win_count
        )

        rank.save!

        i += 1

        puts "Processed #{i} of #{MissionRank.count}..." if i % 10 == 0
      end

      puts "Done!"
    end

    desc "Move mission titles to a separate model"
    task :move_mission_titles_to_model => :environment do
      puts "Moving mission titles..."

      i = 0

      Mission.find_each do |mission|
        next if mission.title.blank?

        title = Title.find_or_create_by_name(mission.title)

        mission.ranks.all(:conditions => {:completed => true}, :include => :character).each do |rank|
          rank.character.titles << title
        end

        mission.title = nil
        mission.payouts = mission.payouts + Payouts::Collection.new(Payouts::Title.new(:value => title))
        mission.save!

        i += 1
      end

      puts "Moved #{i} titles."

      puts "Moving group titles..."

      i = 0

      MissionGroup.find_each do |group|
        next if group.title.blank?

        title = Title.find_or_create_by_name(group.title)

        group.mission_group_ranks.all(:conditions => {:completed => true}, :include => :character).each do |rank|
          rank.character.titles << title
        end

        group.title = nil
        group.payouts << Payouts::Title.new(:value => title)
        group.save!

        i += 1
      end

      puts "Moved #{i} titles."

      puts "Done!"
    end

    desc "Make sure that friend relations are etsablished in both directions"
    task :check_friend_relations => :environment do
      puts "Checking friend relations (#{FriendRelation.count})..."

      restored = 0

      FriendRelation.find_each do |relation|
        unless FriendRelation.first(:conditions => {:owner_id => relation.character_id, :character_id => relation.owner_id})
          FriendRelation.create(
            :owner      => relation.character,
            :character  => relation.owner
          )

          restored += 1
        end
      end

      puts "Done! #{restored} relations restored"
    end

    desc "Assign attributes to mercenries"
    task :assign_attributes_to_mercenaries => :environment do
      puts "Assigning attributes to mercenaries..."

      MercenaryRelation.transaction do
        MercenaryRelation.find_each do |relation|
          relation.send(:copy_owner_attributes)

          relation.save!
        end
      end

      puts "Done!"
    end

    desc "Update total money for characters"
    task :update_total_money_for_characters => :environment do
      Character.update_all "total_money = basic_money + bank"
    end

    desc "Invert visibility settings"
    task :invert_visibility_settings => :environment do
      puts "Inverting visibility settings..."

      Visibility.all(:select => "DISTINCT target_id, target_type").collect(&:target).each do |target|
        puts "%s #%s" % [target.class, target.id]

        Visibility.transaction do
          types_to_add = (CharacterType.all - target.visibilities.character_types)

          target.visibilities.delete_all

          types_to_add.each do |type|
            target.visibilities.create!(:character_type => type)
          end
        end
      end

      puts "Done!"
    end

    desc "Migrate items to payout-based usage system"
    task :use_payouts_for_item_effects => :environment do
      puts "Deleting legacy translations..."

      Translation.delete_all "`key` LIKE 'inventories.use.button%'"

      puts "Hiding currently usable items..."

      Item.scoped(:conditions => {:usable => true}).each do |item|
        item.update_attribute(:usable, false)
        item.hide

        item.inventories.update_all "amount = amount * #{item.usage_limit || 1}"
      end

      puts "Done!"
    end

    desc "Reprocess ass images"
    task :reprocess_images => :environment do
      [Boss, Mission, PropertyType, MissionGroup, CharacterType, Item].each do |klass|
        puts "Reprocessing #{klass.to_s} images (#{klass.count})..."

        klass.all.each do |instance|
          instance.image.reprocess!
        end
      end
    end

    desc "Migrate configuration values to settings"
    task :move_configuration_to_settings => :environment do
      puts "Moving configuration to settings"

      if config = ActiveRecord::Base.connection.select_all("SELECT * FROM configurations").first
        config.except("id", "created_at", "updated_at").each do |key, value|
          Setting[key] = value
        end

        puts "Done!"
      else
        puts "Configuration not found"
      end
    end

    desc "Auto-equip inventories"
    task :auto_equip_inventories => :environment do
      count = Inventory.equippable.count

      puts "Equipping #{count} inventories..."

      Inventory.equippable.all(:include => [{:character => :character_type}, :item], :order => "items.vip_price DESC, items.basic_price DESC").each_with_index do |inventory, index|
        inventory.character.equipment.auto_equip!(inventory)

        puts "Equipped #{index}/#{count} inventories..." if index % 10 == 0
      end

      puts "Done!"
    end

    desc "Set default states to objects"
    task :set_default_states => :environment do
      %w{bosses item_groups items mission_groups missions property_types}.each do |t|
        t.classify.constantize.update_all "state = 'visible'"
      end
    end

    desc "Update translation strings to use interpolations"
    task :translations_to_interpolations => :environment do
      puts "Modifying interpolations for #{Translation.count} translations..."

      Translation.find_each do |t|
        t.value = t.value.gsub(/([^\{]|\A)\{([^\{])/, "\\1{{\\2")
        t.value = t.value.gsub(/([^\}])\}([^\}]|\Z)/, "\\1}}\\2")
        t.save!
      end

      puts "Done!"
    end

    desc "Update payout triggers"
    task :update_payout_events => :environment do
      Promotion.all.each do |pr|
        pr.payouts.each do |p|
          p.apply_on = :success
        end

        pr.save
      end
    end

    desc "Set default values to owned items"
    task :set_defaults_to_owned_items => :environment do
      Item.update_all "owned = 0", "owned IS NULL"
    end

    desc "Calculate owned_items"
    task :calculate_owned_items => :environment do
      Item.find_each do |item|
        item.update_attribute(:owned, item.inventories.sum(:amount))
      end
    end

    desc "Move item, mission, and property images"
    task :move_images_to_new_urls => :environment do
      [Item, Mission, PropertyType, MissionGroup].each do |klass|
        total = klass.count

        klass.find_each do |item|
          puts "Processing #{klass.to_s.humanize} #{item.id}/#{total}..."

          if item.image?
            old_file_name = File.join(RAILS_ROOT, "public", "system", "images", item.id.to_s, "original", item.image_file_name)

            if File.file?(old_file_name)
              item.image = File.open(old_file_name)
              item.save!
            else
              puts "File not found: #{old_file_name}"
            end
          end
        end
      end
    end

    desc "Recalculate character rating"
    task :recalculate_rating => :environment do
      Character.find_.each do |character|
        character.send(:recalculate_rating)
        character.save
      end
    end

    desc "Mark all relations as friends"
    task :mark_relations_as_friends => :environment do
      Relation.update_all "type='FriendRelation'"
    end

    desc "Add counter caches to character"
    task :character_counter_caches => :environment do
      Character.update_all("fights_won = (SELECT COUNT(*) FROM fights WHERE winner_id = characters.id)")
      Character.update_all("fights_lost = (SELECT COUNT(*) FROM fights WHERE (attacker_id = characters.id OR victim_id = characters.id) AND winner_id != characters.id)")
      Character.update_all("missions_succeeded = (SELECT sum(win_count) FROM ranks WHERE character_id = characters.id)")
      Character.update_all("missions_completed = (SELECT count(*) FROM ranks WHERE character_id = characters.id AND completed = 1)")

      Character.update_all("relations_count = (SELECT count(*) FROM relations WHERE source_id = characters.id)")
    end

    desc "Group properties"
    task :group_properties => :environment do
      property_types = PropertyType.all

      total = Character.count
      i = 1

      Character.find_each(:batch_size => 100) do |character|
        puts "Processing character #{i}/#{total}"

        properties = property_types.inject({}) do |result, type|
          count = character.properties.count(:conditions => ["property_type_id = ?", type.id])

          result[type] = count if count > 0
          result
        end

        Character.transaction do
          character.properties.delete_all

          properties.each do |type, amount|
            character.properties.give(type, amount)
          end

          character.save

          character.recalculate_income
        end

        i+= 1
      end
    end

    desc "Group inventories"
    task :group_inventories => :environment do
      puts "Processing item effects"

      Item.find_each do |item|
        collection = Effects::Collection.new

        item.effects.each do |effect|
          if effect.is_a?(YAML::Object)
            case effect.class
            when "Effects::Attack"
              item.attack = effect.ivars["value"]
            when "Effects::Defence"
              item.defence = effect.ivars["value"]
            end
          else
            collection << Effects::Collection.new(effect)
          end
        end

        item.effects = collection

        item.save
      end

      total = Character.count

      i = 1

      Character.find_each do |character|
        puts "Processing character #{i}/#{total}"

        items = character.inventories.inject({}) do |result, inventory|
          result[inventory.item] ||= 0
          result[inventory.item] += 1
          result
        end

        Character.transaction do
          character.inventories.delete_all

          items.each do |item, amount|
            character.inventories.give(item, amount)
          end

          character.save

          character.inventories.calculate_used_in_fight!
        end

        i+= 1
      end
    end
  end
end
