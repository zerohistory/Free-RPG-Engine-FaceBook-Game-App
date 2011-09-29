class AddAccessTokenToUser < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :access_token, :null => false
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :access_token
    end
  end
end
