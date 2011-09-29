class AddEmailToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :email, :string, :default => "", :null => false
  end

  def self.down
    remove_column :users, :email
  end
end
