class AddLoserMoneyToFights < ActiveRecord::Migration
  def self.up
    change_table :fights do |t|
      t.rename  :money, :winner_money
      t.integer :loser_money
    end

    Fight.update_all "loser_money = winner_money"
  end

  def self.down
    change_table :fights do |t|
      t.rename  :winner_money, :money
      t.remove  :loser_money
    end
  end
end
