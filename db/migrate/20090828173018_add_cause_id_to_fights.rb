class AddCauseIdToFights < ActiveRecord::Migration
  def self.up
    add_column :fights, :cause_id, :integer

    add_index :fights, :cause_id
  end

  def self.down
    remove_column :fights, :cause_id
  end
end
