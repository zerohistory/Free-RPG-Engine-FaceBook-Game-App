class RenameSkipTutorialToShowTutorial < ActiveRecord::Migration
  def self.up
    add_column :users, :show_tutorial, :boolean, :default => true

    User.update_all "show_tutorial = 0", "skip_tutorial = 1"
    
    remove_column :users, :skip_tutorial
  end

  def self.down
    add_column :users, :skip_tutorial, :boolean

    User.update_all "skip_tutorial = 1", "show_tutorial = 0"

    remove_column :users, :show_tutorial
  end
end
