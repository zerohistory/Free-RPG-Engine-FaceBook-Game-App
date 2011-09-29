class AddPayoutsToMissions < ActiveRecord::Migration
  def self.up
    add_column :missions, :payouts, :text
  end

  def self.down
    remove_column :missions, :payouts
  end
end
