class MakeNotificationReferencesFlexible < ActiveRecord::Migration
  def self.up
    Notification::Base.delete_all

    change_table :notifications do |t|
      t.remove :reference_id
      t.remove :reference_type

      t.text :data
    end
  end

  def self.down
    Notification::Base.delete_all
    
    change_table :notifications do |t|
      t.integer :reference_id
      t.string  :reference_type, :limit => 100

      t.remove :data
    end
  end
end
