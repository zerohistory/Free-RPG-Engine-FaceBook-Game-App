class CreatePropertySets < ActiveRecord::Migration
  def self.up
    create_table :property_sets do |t|
      t.string   "name"
      t.string   "property_ids",   :limit => 2048
      t.datetime "created_at"
      t.datetime "updated_at"

      t.timestamps
    end
  end

  def self.down
    drop_table :property_sets
  end
end
