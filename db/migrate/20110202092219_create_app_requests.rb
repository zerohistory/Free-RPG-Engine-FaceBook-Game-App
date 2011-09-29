class CreateAppRequests < ActiveRecord::Migration
  def self.up
    create_table :app_requests do |t|
      t.column :facebook_id, :bigint
      
      t.integer :sender_id
      t.column  :receiver_id, :bigint
      
      t.text    :data
      
      t.timestamps
    end
  end

  def self.down
    drop_table :app_requests
  end
end
