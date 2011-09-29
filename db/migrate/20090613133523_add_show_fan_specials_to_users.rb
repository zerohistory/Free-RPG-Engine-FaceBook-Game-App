class AddShowFanSpecialsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :show_fan_specials, :boolean, :default => true
  end

  def self.down
    remove_column :users, :show_fan_specials
  end
end
