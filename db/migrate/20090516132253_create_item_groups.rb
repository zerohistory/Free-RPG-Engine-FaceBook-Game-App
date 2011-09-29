class CreateItemGroups < ActiveRecord::Migration
  def self.up
    create_table :item_groups do |t|
      t.string  :name
      t.integer :position
      
      t.timestamps
    end

    add_column :items, :item_group_id, :integer
    add_index :items, :item_group_id
    
    remove_column :items, :type
  end

  def self.down
    drop_table :item_groups

    remove_column :items, :item_group_id
    
    add_column :items, :type
  end
end
