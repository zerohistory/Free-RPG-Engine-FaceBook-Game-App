class RemoveFightWithInviteFieldsFromConfiguration < ActiveRecord::Migration
  def self.up
    change_table :configurations do |t|
      t.remove  "fight_with_invite_allowed"
      t.remove  "fight_with_invite_stamina_required"
      t.remove  "fight_with_invite_max_level"
      t.remove  "fight_with_invite_experience"
      t.remove  "fight_with_invite_money_min"
      t.remove  "fight_with_invite_money_max"
      t.remove  "fight_with_invite_victim_damage_max"
      t.remove  "fight_with_invite_victim_damage_min"
      t.remove  "fight_with_invite_attacker_damage"
    end
  end

  def self.down
    change_table :configurations do |t|
      t.boolean  "fight_with_invite_allowed",                             :default => true
      t.integer  "fight_with_invite_stamina_required",                    :default => 1
      t.integer  "fight_with_invite_max_level",                           :default => 20
      t.integer  "fight_with_invite_experience",                          :default => 50
      t.integer  "fight_with_invite_money_min",                           :default => 5
      t.integer  "fight_with_invite_money_max",                           :default => 10
      t.integer  "fight_with_invite_victim_damage_max",                   :default => 25
      t.integer  "fight_with_invite_victim_damage_min",                   :default => 10
      t.integer  "fight_with_invite_attacker_damage",                     :default => 80
    end
  end
end
