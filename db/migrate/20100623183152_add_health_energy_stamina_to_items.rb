class AddHealthEnergyStaminaToItems < ActiveRecord::Migration
  def self.up
    change_table :items do |t|
      t.integer :health
      t.integer :energy
      t.integer :stamina
    end
  end

  def self.down
    change_table :items do |t|
      t.remove :health
      t.remove :energy
      t.remove :stamina
    end
  end
end
