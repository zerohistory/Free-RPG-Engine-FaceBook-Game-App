class AddReferrerIdToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.integer :referrer_id
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :referrer_id
    end
  end
end
