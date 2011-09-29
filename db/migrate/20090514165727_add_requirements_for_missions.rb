class AddRequirementsForMissions < ActiveRecord::Migration
  def self.up
    add_column :missions, :requirements, :text
  end

  def self.down
    remove_column :missions, :requirements
  end
end
