class AddShowBookmarkToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :show_bookmark, :boolean, :default => true
  end

  def self.down
    remove_column :users, :show_bookmark
  end
end
