class CreateItemSets < ActiveRecord::Migration
  def self.up
    create_table :item_sets do |t|
      t.string  :name
      t.string  :item_ids, :limit => 2048

      t.timestamps
    end
  end

  def self.down
    drop_table :item_sets
  end
end
