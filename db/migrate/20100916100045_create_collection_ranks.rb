class CreateCollectionRanks < ActiveRecord::Migration
  def self.up
    create_table :collection_ranks do |t|
      t.integer :character_id
      t.integer :collection_id

      t.integer :collection_count

      t.timestamps
    end
  end

  def self.down
    drop_table :collection_ranks
  end
end
