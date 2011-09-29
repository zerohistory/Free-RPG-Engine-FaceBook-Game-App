class RenameWorkflowStateToStateForNewsletters < ActiveRecord::Migration
  def self.up
    rename_column :newsletters, :workflow_state, :state
  end

  def self.down
    rename_column :newsletters, :state, :workflow_state
  end
end
