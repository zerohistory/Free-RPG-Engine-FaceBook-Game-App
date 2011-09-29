class AddThirdPartyIdToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.datetime  :access_token_expire_at
      t.string    :third_party_id, :limit => 50, :null => false, :default => ''
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :access_token_expire_at
      t.remove :third_party_id
    end
  end
end
