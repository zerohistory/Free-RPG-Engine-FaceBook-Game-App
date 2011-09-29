class AddRequirementsToMissionGroups < ActiveRecord::Migration
  def self.up
    change_table :mission_groups do |t|
      t.text :requirements
      
      t.boolean :hide_unsatisfied
    end
  end

  def self.down
    change_table :mission_groups do |t|
      t.remove :requirements

      t.remove :hide_unsatisfied
    end
  end
end