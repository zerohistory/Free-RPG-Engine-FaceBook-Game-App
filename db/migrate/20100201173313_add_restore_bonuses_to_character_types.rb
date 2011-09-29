class AddRestoreBonusesToCharacterTypes < ActiveRecord::Migration
  def self.up
    change_table :character_types do |t|
      t.integer :health_restore_bonus,  :default => 0
      t.integer :energy_restore_bonus,  :default => 0
      t.integer :stamina_restore_bonus, :default => 0
      t.integer :income_period_bonus,   :default => 0
    end
  end

  def self.down
    change_table :character_types do |t|
      t.remove :health_restore_bonus
      t.remove :energy_restore_bonus
      t.remove :stamina_restore_bonus
      t.remove :income_period_bonus
    end
  end
end
