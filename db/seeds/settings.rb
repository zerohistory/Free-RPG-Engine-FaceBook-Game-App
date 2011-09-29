puts "Seeding settings..."

Setting[:assignment_mercenaries]                ||= true
Setting[:assignment_attack_bonus]               ||= 20
Setting[:assignment_defence_bonus]              ||= 20
Setting[:assignment_fight_damage_multiplier]    ||= 3.5
Setting[:assignment_fight_damage_divider]       ||= 2.0
Setting[:assignment_fight_income_multiplier]    ||= 2.0
Setting[:assignment_fight_income_divider]       ||= 1.0
Setting[:assignment_mission_energy_multiplier]  ||= 1.0
Setting[:assignment_mission_energy_divider]     ||= 4.0
Setting[:assignment_mission_income_multiplier]  ||= 4.0
Setting[:assignment_mission_income_divider]     ||= 2.0

Setting[:bank_deposit_fee] ||= 10

Setting[:character_attack_upgrade] ||= 1
Setting[:character_defence_upgrade] ||= 1
Setting[:character_health_upgrade] ||= 5
Setting[:character_energy_upgrade] ||= 1
Setting[:character_points_per_upgrade] ||= 5
Setting[:character_vip_money_per_upgrade] ||= 0
Setting[:character_vip_money_per_upgrade_per_level] ||= 0
Setting[:character_stamina_upgrade] ||= 1
Setting[:character_stamina_upgrade_points] ||= 2
Setting[:character_attack_upgrade_points] ||= 1
Setting[:character_defence_upgrade_points] ||= 1
Setting[:character_health_upgrade_points] ||= 1
Setting[:character_energy_upgrade_points] ||= 1

Setting[:character_health_restore_period] ||= 60
Setting[:character_energy_restore_period] ||= 120
Setting[:character_stamina_restore_period] ||= 180
Setting[:character_income_calculation_period] ||= 60
Setting[:character_weakness_minimum] ||= 5

Setting[:premium_money_price] ||= 5
Setting[:premium_money_amount] ||= 1000
Setting[:premium_energy_price] ||= 5
Setting[:premium_health_price] ||= 1
Setting[:premium_points_price] ||= 5
Setting[:premium_points_amount] ||= 5
Setting[:premium_mercenary_price] ||= 10
Setting[:premium_change_name_price] ||= 10
Setting[:premium_reset_attributes_price] ||= 10
Setting[:premium_stamina_price] ||= 5

Setting[:fight_victim_show_limit] ||= 10
Setting[:fight_victim_levels_lower] ||= 0
Setting[:fight_victim_levels_higher] ||= 5
Setting[:fight_attack_repeat_delay] ||= 60
Setting[:fight_stamina_required] ||= 1
Setting[:fight_experience] ||= 50
Setting[:fight_money_loot] ||= 10
Setting[:fight_max_loser_damage] ||= 50
Setting[:fight_max_winner_damage] ||= 90
Setting[:fight_latest_show_limit] ||= 10
Setting[:fight_alliance_attack] ||= true
Setting[:fight_max_money] ||= 10000
Setting[:fight_min_money] ||= 10
Setting[:fight_min_money_per_level] ||= 1.5
Setting[:fight_max_difference] ||= 30
Setting[:fight_weak_opponents] ||= true

Setting[:rating_show_limit] ||= 20

Setting[:inventory_sell_price] ||= 50

Setting[:item_show_basic] ||= 10
Setting[:item_show_special] ||= 3

Setting[:property_sell_price] ||= 50
Setting[:property_upgrade_limit] ||= 2000

Setting[:user_tutorial_enabled] ||= true
Setting[:user_admins] ||= "682180971, 573513043"

Setting[:invitation_direct_link] ||= false

Setting[:relation_show_limit]         ||= 10
Setting[:relation_max_alliance_size]  ||= 500
Setting[:relation_friends_only]       ||= false

Setting[:mission_group_show_limit] ||= 4
Setting[:mission_completion_dialog] ||= true
Setting[:mission_help_money] ||= 25
Setting[:mission_help_experience] ||= 25

Setting[:app_google_analytics_id] ||= ""

Setting[:gifting_enabled] ||= true
Setting[:gifting_item_show_limit] ||= 10
Setting[:gifting_repeat_accept_delay] ||= 24
Setting[:gifting_accept_all] ||= false

Setting[:wall_enabled] ||= true
Setting[:wall_posts_show_limit] ||= 10

Setting[:boss_max_loser_damage] ||= 10
Setting[:boss_max_winner_damage] ||= 10

Setting[:character_default_name] ||= ""
Setting[:character_equipment_slots] ||= 5
Setting[:character_auto_equipment] ||= false
Setting[:character_relations_per_equipment_slot] ||= 3

Setting[:hit_list_enabled] ||= true
Setting[:hit_list_minimum_reward] ||= 10_000
Setting[:hit_list_reward_fee] ||= 20
Setting[:hit_list_display_limit] ||= 20
Setting[:hit_list_repeat_listing_delay] ||= 12

Setting[:hospital_enabled] ||= true
Setting[:hospital_price] ||= 10
Setting[:hospital_price_per_point_per_level] ||= 2.5
Setting[:hospital_delay] ||= 5
Setting[:hospital_delay_per_level] ||= 1

Setting[:market_enabled]          ||= true
Setting[:market_basic_price_fee]  ||= 10
Setting[:market_vip_price_fee]    ||= 10
Setting[:market_expire_period]    ||= 24

Setting[:collections_enabled] ||= true
Setting[:collections_request_time] ||= 48

Setting[:boosts_enabled] ||= false

Setting[:monsters_enabled] ||= true
Setting[:monsters_reward_time] ||= 24
Setting[:monster_minimum_damage] ||= 10

Setting[:notifications_friends_to_invite_delay] ||= 48
Setting[:notifications_friends_to_invite_displayed_at] ||= Time.now

Setting[:notifications_send_gift_delay] ||= 48
Setting[:notifications_send_gift_displayed_at] ||= Time.now + 24.hours

# Put your custom settings below this line