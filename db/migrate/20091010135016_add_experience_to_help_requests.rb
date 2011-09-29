class AddExperienceToHelpRequests < ActiveRecord::Migration
  def self.up
    add_column :help_requests, :experience, :integer, :default => 0
  end

  def self.down
    remove_column :help_requests, :experience
  end
end
