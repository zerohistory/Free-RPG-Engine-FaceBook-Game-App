class RenameCollectionsToItemCollections < ActiveRecord::Migration
  def self.up
    rename_table :collections, :item_collections
    rename_table :collection_ranks, :item_collection_ranks
  end

  def self.down
    rename_table :item_collections, :collections
    rename_table :item_collection_ranks, :collection_ranks
  end
end
