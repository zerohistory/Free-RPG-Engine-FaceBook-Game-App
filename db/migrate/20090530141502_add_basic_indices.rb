class AddBasicIndices < ActiveRecord::Migration
  def self.up
    add_index :assignments, [:context_id, :context_type]
    add_index :assignments, :relation_id

    add_index :bank_operations, :character_id

    add_index :characters, :user_id
    add_index :characters, :rating
    add_index :characters, :level

    add_index :fights, [:attacker_id, :winner_id]
    add_index :fights, :victim_id

    add_index :inventories, [:character_id, :placement]

    add_index :properties, :character_id

    add_index :ranks, [:character_id, :mission_id]
  end

  def self.down
    remove_index :assignments, :column => [:context_id, :context_type]
    remove_index :assignments, :column => :relation_id

    remove_index :bank_operations, :column => :character_id

    remove_index :characters, :column => :user_id
    remove_index :characters, :column => :rating
    remove_index :characters, :column => :level

    remove_index :fights, :column => [:attacker_id, :winner_id]
    remove_index :fights, :column => :victim_id

    remove_index :inventories, :column => [:character_id, :placement]

    remove_index :properties, :column => :character_id

    remove_index :ranks, :column => [:character_id, :mission_id]
  end
end
