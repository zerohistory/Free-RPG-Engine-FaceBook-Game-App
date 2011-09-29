class MakeHelpRequestsPolymorphic < ActiveRecord::Migration
  def self.up
    rename_column :help_requests, :mission_id, :context_id
    
    add_column :help_requests, :context_type, :string, :limit => 30

    add_column :fights, :cause_type, :string, :limit => 30
  end

  def self.down
    rename_column :help_requests, :context_id, :mission_id

    remove_column :help_requests, :context_type

    remove_column :fights, :cause_type
  end
end
