class AddRepeatableToMission < ActiveRecord::Migration
  def self.up
    add_column :missions, :repeatable, :boolean
  end

  def self.down
    remove_column :missions, :repeatable
  end
end
