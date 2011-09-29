class CreateStories < ActiveRecord::Migration
  def self.up
    create_table :stories do |t|
      t.string    :alias, :limit => 70, :null => false, :default => ''
      
      t.string    :title,       :limit => 200,  :null => false, :default => ''
      t.string    :description, :limit => 200,  :null => false, :default => ''
      t.string    :action_link, :limit => 50,   :null => false, :default => ''
      
      t.string    :payout_message, :null => false, :default => ''
      
      t.string    :image_file_name,                   :default => "", :null => false
      t.string    :image_content_type, :limit => 100, :default => "", :null => false
      t.integer   :image_file_size
      t.datetime  :image_updated_at

      t.text :payouts
      
      t.string :state, :limit => 50, :null => false, :default => ''
      
      t.timestamps
    end
    
    create_table :story_visits do |t|
      t.integer :character_id

      t.integer :story_id
      t.string  :story_alias, :limit => 70, :null => false, :default => ''
      t.integer :reference_id
      
      t.timestamps
    end
    
    add_index :story_visits, [:character_id, :story_alias, :reference_id]
  end

  def self.down
    drop_table :stories
    drop_table :story_visits
  end
end
