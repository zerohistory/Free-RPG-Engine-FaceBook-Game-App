class AddPositionToMissions < ActiveRecord::Migration
  def self.up
    change_table :missions do |t|
      t.integer :position
    end

    Rake::Task["app:maintenance:enumerate_missions"].execute
  end

  def self.down
    change_table :missions do |t|
      t.remove :position
    end
  end
end
