class CreateConfigurations < ActiveRecord::Migration
  def self.up
    create_table :configurations do |t|
      t.integer :assignment_attack_bonus,             :default => 20
      t.integer :assignment_defence_bonus,            :default => 20
      t.float   :assignment_fight_damage_multiplier,    :default => 3.5
      t.float   :assignment_fight_damage_divider,       :default => 1
      t.float   :assignment_fight_income_multiplier,    :default => 2
      t.float   :assignment_fight_income_divider,       :default => 1
      t.float   :assignment_mission_energy_multiplier,  :default => 1
      t.float   :assignment_mission_energy_divider,     :default => 4
      t.float   :assignment_mission_income_multiplier,  :default => 4
      t.float   :assignment_mission_income_divider,     :default => 2

      t.integer :bank_deposit_fee, :default => 10

      t.integer :character_attack_upgrade,  :default => 1
      t.integer :character_defence_upgrade, :default => 1
      t.integer :character_health_upgrade,  :default => 5
      t.integer :character_energy_upgrade,  :default => 1

      t.integer :character_health_restore_period,     :default => 60
      t.integer :character_energy_restore_period,     :default => 120
      t.integer :character_income_calculation_period, :default => 60
      
      t.integer :character_weakness_minimum,      :default => 20
      t.integer :character_points_per_upgrade,    :default => 5
      t.integer :character_vip_money_per_upgrade, :default => 0

      t.integer :premium_money_price,     :default => 5
      t.integer :premium_money_amount,    :default => 1000
      t.integer :premium_energy_price,    :default => 5
      t.integer :premium_health_price,    :default => 1
      t.integer :premium_points_price,    :default => 5
      t.integer :premium_points_amount,   :default => 5
      t.integer :premium_mercenary_price, :default => 10

      t.integer :fight_victim_show_limit,     :default => 10
      t.integer :fight_victim_levels_lower,   :default => 0
      t.integer :fight_victim_levels_higher,  :default => 5
      t.integer :fight_attack_repeat_delay,   :default => 60
      t.integer :fight_energy_required,       :default => 1
      t.integer :fight_experience,            :default => 50
      t.integer :fight_money_loot,            :default => 10
      t.integer :fight_max_loser_damage,      :default => 50
      t.integer :fight_max_winner_damage,     :default => 90
      t.integer :fight_latest_show_limit, :default => 10
      t.boolean :fight_with_invite_allowed, :default => true
      t.integer :fight_with_invite_energy_required, :default => 1
      t.integer :fight_with_invite_max_level, :default => 20
      t.integer :fight_with_invite_experience,  :default => 50
      t.integer :fight_with_invite_money_min,   :default => 5
      t.integer :fight_with_invite_money_max,   :default => 10
      t.integer :fight_with_invite_victim_damage_max,   :default => 25
      t.integer :fight_with_invite_victim_damage_min,   :default => 10
      t.integer :fight_with_invite_attacker_damage, :default => 80

      t.integer :rating_missions_completed, :default => 500
      t.integer :rating_relations,          :default => 100
      t.integer :rating_fights_won,         :default => 10
      t.integer :rating_missions_succeeded, :default => 5
      t.integer :rating_income_divider,     :default => 5
      t.integer :rating_income_ceil,        :default => 50000
      t.integer :rating_show_limit,         :default => 20

      t.integer :help_request_expire_period,  :default => 24
      t.integer :help_request_display_period, :default => 24
      t.integer :help_request_mission_money,      :default => 5
      t.integer :help_request_mission_experience, :default => 10
      t.integer :help_request_fight_money,      :default => 10
      t.integer :help_request_fight_experience, :default => 20

      t.integer :inventory_sell_price, :default => 50

      t.integer :item_show_basic, :default => 10
      t.integer :item_show_special, :default => 3

      t.integer :property_sell_price, :default => 50
      t.integer :property_maximum_amount, :default => 2000

      t.boolean :user_tutorial_enabled, :default => true
      t.boolean :user_invite_page_redirect_enabled, :default => true
      t.integer :user_invite_page_first_visit_delay, :default => 1
      t.integer :user_invite_page_recurrent_visit_delay, :default => 48
      t.string  :user_admins, :default => "682180971"

      t.integer :relation_show_limit, :default => 10

      t.integer :newsletter_recipients_per_send, :default => 50
      t.integer :newsletter_send_sleep, :default => 60

      t.timestamps
    end
  end

  def self.down
    drop_table :configurations
  end
end
