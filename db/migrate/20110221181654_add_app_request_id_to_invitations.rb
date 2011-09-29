class AddAppRequestIdToInvitations < ActiveRecord::Migration
  def self.up
    change_table :invitations do |t|
      t.integer :app_request_id
    end
  end

  def self.down
    change_table :invitations do |t|
      t.remove :app_request_id
    end
  end
end
