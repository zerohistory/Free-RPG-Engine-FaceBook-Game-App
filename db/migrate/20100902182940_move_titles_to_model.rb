class MoveTitlesToModel < ActiveRecord::Migration
  def self.up
    create_table :titles do |t|
      t.string :name
      t.string :state, :limit => 50
      
      t.timestamps
    end

    create_table :character_titles do |t|
      t.integer :character_id
      t.integer :title_id

      t.timestamps
    end

    Rake::Task["app:maintenance:move_mission_titles_to_model"].execute

    change_table :missions do |t|
      t.remove :title
    end

    change_table :mission_groups do |t|
      t.remove :title
    end
  end

  def self.down
    drop_table :titles
    drop_table :character_titles

    change_table :missions do |t|
      t.string :title
    end

    change_table :mission_groups do |t|
      t.string :title
    end
  end
end
