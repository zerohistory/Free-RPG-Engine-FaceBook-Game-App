class AddFightMaxMoneyToConfigurations < ActiveRecord::Migration
  def self.up
    add_column :configurations, :fight_max_money, :integer, :default => 10000
  end

  def self.down
    remove_column :configurations, :fight_max_money
  end
end
