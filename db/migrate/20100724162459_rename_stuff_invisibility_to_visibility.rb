class RenameStuffInvisibilityToVisibility < ActiveRecord::Migration
  def self.up
    rename_table :stuff_invisibilities, :visibilities

    change_table :visibilities do |t|
      t.rename :stuff_id,   :target_id
      t.rename :stuff_type, :target_type
    end

    Rake::Task["app:maintenance:invert_visibility_settings"].execute
  end

  def self.down
    rename_table :visibilities, :stuff_invisibilities

    change_table :stuff_invisibilities do |t|
      t.rename :target_id,    :stuff_id
      t.rename :target_type,  :stuff_type
    end
  end
end
