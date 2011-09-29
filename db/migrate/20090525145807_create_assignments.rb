class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :assignments do |t|
      t.integer :relation_id

      t.integer :context_id
      t.string  :context_type

      t.string  :role

      t.timestamps
    end
  end

  def self.down
    drop_table :assignments
  end
end
