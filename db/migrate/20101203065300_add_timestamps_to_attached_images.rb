class AddTimestampsToAttachedImages < ActiveRecord::Migration
  CLASSES = [Asset, Boss, CharacterType, Item, Mission, MissionGroup, PropertyType]

  def self.up
    CLASSES.each do |klass|
      add_column klass.table_name, :image_updated_at, :datetime

      klass.update_all({:image_updated_at => Time.now}, "image_file_name IS NOT NULL")
    end
  end

  def self.down
    CLASSES.each do |klass|
      remove_column klass.table_name, :image_updated_at
    end
  end
end
