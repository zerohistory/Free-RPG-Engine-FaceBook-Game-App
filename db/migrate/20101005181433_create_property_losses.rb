class CreatePropertyLosses < ActiveRecord::Migration
  def self.up
    create_table :property_losses do |t|
      t.integer :property_type_id, :null => false
      t.integer :fight_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :property_losses
  end
end
