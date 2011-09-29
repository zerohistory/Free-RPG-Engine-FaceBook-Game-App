class AddRequirementsToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :requirements, :text
  end

  def self.down
    remove_column :items, :requirements
  end
end
