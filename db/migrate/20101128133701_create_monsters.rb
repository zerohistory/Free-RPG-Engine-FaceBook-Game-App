class CreateMonsters < ActiveRecord::Migration
  def self.up
    create_table :monster_types do |t|
      t.integer :level, :default => 1
      
      t.string  :name,              :limit => 100, :default => '', :null => false
      t.text    :description

      t.integer :health
      t.integer :attack
      t.integer :defence
      t.integer :minimum_damage, :maximum_damage
      t.integer :minimum_response, :maximum_response

      t.integer :experience
      t.integer :money

      t.text    :requirements
      t.text    :payouts

      t.string  :image_file_name,                   :default => "", :null => false
      t.string  :image_content_type, :limit => 100, :default => "", :null => false
      t.integer :image_file_size

      t.integer :fight_time,    :default => 12

      t.string  :state, :limit => 50, :default => '', :null => false

      t.timestamps
    end

    create_table :monsters do |t|
      t.integer   :character_id
      t.integer   :monster_type_id

      t.integer   :hp

      t.string    :state, :limit => 50, :default => '', :null => false

      t.datetime  :expire_at
      t.datetime  :defeated_at

      t.integer   :lock_version, :default => 0
      t.timestamps
    end

    create_table :monster_fights do |t|
      t.integer :character_id
      t.integer :monster_id
      
      t.integer :damage, :default => 0

      t.boolean :reward_collected

      t.timestamps
    end
  end

  def self.down
    drop_table :monster_types
    drop_table :monsters
    drop_table :monster_fights
  end
end
