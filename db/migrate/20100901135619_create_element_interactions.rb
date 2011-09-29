class CreateElementInteractions < ActiveRecord::Migration
  def self.up
    create_table :element_interactions do |t|
      t.integer :attack_element, :null => false
      t.integer :defence_element, :null => false
      t.float :factor, :null => false, :default => 1.0

      t.timestamps
    end
  end

  def self.down
    drop_table :element_interactions
  end
end
