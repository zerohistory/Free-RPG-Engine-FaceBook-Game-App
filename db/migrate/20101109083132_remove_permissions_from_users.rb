class RemovePermissionsFromUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.remove :permission_email
      t.remove :permissions_requested_at
    end
  end

  def self.down
    change_table :users do |t|
      t.boolean  :permission_email
      t.datetime :permissions_requested_at
    end
  end
end
