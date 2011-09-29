class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.integer :sender_id
      t.integer :receiver_id,     :limit => 8
      t.boolean :accepted
      
      t.timestamps
    end

    add_index :invitations, [:receiver_id, :accepted]
    add_index :invitations, :sender_id
  end

  def self.down
    drop_table :invitations
  end
end
