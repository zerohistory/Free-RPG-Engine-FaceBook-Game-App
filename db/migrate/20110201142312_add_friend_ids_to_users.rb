class AddFriendIdsToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.text :friend_ids
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :friend_ids
    end
  end
end
