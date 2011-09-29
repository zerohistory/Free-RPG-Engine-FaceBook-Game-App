class SetDefaultCounterForItemCollectionRank < ActiveRecord::Migration
  def self.up
    change_column :item_collection_ranks, :collection_count, :integer, :default => 0
  end

  def self.down
    change_column :item_collection_ranks, :collection_count, :integer, :default => nil
  end
end
