class CreateRelations < ActiveRecord::Migration
  def self.up
    create_table :relations do |t|
      t.integer :source_id
      t.integer :target_id
      
      t.timestamps
    end

    add_index :relations, [:source_id, :target_id]
  end

  def self.down
    drop_table :relations
  end
end
