class AddSkipTutorialToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :skip_tutorial, :boolean
  end

  def self.down
    remove_column :users, :skip_tutorial
  end
end
