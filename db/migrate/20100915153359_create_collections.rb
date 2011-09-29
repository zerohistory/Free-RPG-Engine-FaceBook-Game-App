class CreateCollections < ActiveRecord::Migration
  def self.up
    create_table :collections do |t|
      t.string  :name
      t.string  :item_ids
      t.text    :payouts
      t.string  :state, :limit => 30
      
      t.timestamps
    end
  end

  def self.down
    drop_table :collections
  end
end
