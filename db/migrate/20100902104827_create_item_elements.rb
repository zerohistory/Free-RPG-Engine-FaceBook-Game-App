class CreateItemElements < ActiveRecord::Migration
  def self.up
    create_table :item_elements do |t|
      t.integer :item_id, :null => false
      t.integer :element_id, :null => false
      t.integer :count, :null => false, :default => 1
      t.integer :effect_type, :null => false, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :item_elements
  end
end
