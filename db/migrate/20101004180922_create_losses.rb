class CreateLosses < ActiveRecord::Migration
  def self.up
    create_table :losses do |t|
      t.integer :item_id, :null => false
      t.integer :fight_id, :null => false
      t.integer :amount, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :losses
  end
end
