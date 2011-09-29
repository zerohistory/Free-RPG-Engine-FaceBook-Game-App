class CreateFights < ActiveRecord::Migration
  def self.up
    create_table :fights do |t|
      t.integer :attacker_id
      t.integer :victim_id
      t.integer :winner_id

      t.integer :attacker_hp_loss
      t.integer :victim_hp_loss

      t.integer :experience
      t.integer :money

      t.timestamps
    end
  end

  def self.down
    drop_table :fights
  end
end
