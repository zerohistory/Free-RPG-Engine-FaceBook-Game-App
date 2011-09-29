class AddUsageTypeToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :usage_type, :string, :default => "all"
  end

  def self.down
    remove_column :items, :usage_type
  end
end
