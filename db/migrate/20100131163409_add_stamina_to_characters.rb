class AddStaminaToCharacters < ActiveRecord::Migration
  def self.up
    change_table :characters do |t|
      t.integer   :stamina, :default => 10
      t.integer   :sp,      :default => 10
      t.datetime  :sp_updated_at
    end

    change_table :character_types do |t|
      t.integer :stamina, :default => 10
    end

    change_table :configurations do |t|
      t.integer :character_stamina_restore_period,  :default => 180
      t.integer :premium_stamina_price,             :default => 5
      t.integer :character_stamina_upgrade,         :default => 1
      t.integer :character_stamina_upgrade_points,  :default => 2
      t.integer :character_attack_upgrade_points,   :default => 1
      t.integer :character_defence_upgrade_points,  :default => 1
      t.integer :character_health_upgrade_points,   :default => 1
      t.integer :character_energy_upgrade_points,   :default => 1
      
      t.rename  :fight_energy_required, :fight_stamina_required
      t.rename  :fight_with_invite_energy_required, :fight_with_invite_stamina_required
    end
  end

  def self.down
    change_table :characters do |t|
      t.remove :stamina
      t.remove :sp
      t.remove :sp_updated_at
    end

    change_table :character_types do |t|
      t.remove :stamina
    end

    change_table :configurations do |t|
      t.remove :character_stamina_restore_period
      t.remove :premium_stamina_price
      t.remove :character_stamina_upgrade
      t.remove :character_stamina_upgrade_points
      t.remove :character_attack_upgrade_points
      t.remove :character_defence_upgrade_points
      t.remove :character_health_upgrade_points
      t.remove :character_energy_upgrade_points

      t.rename :fight_stamina_required, :fight_energy_required
      t.rename :fight_with_invite_stamina_required, :fight_with_invite_energy_required
    end
  end
end
