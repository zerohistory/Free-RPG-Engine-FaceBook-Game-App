class CreateWallPosts < ActiveRecord::Migration
  def self.up
    create_table :wall_posts do |t|
      t.integer :character_id
      t.integer :author_id

      t.text    :text, :limit => 4.kilobytes

      t.timestamps
    end

    change_table :users do |t|
      t.integer :wall_privacy_level, :default => WallPost::PRIVACY_LEVEL[:public]
    end
  end

  def self.down
    drop_table :wall_posts

    change_table :users do |t|
      t.integer :wall_privacy_level
    end
  end
end
