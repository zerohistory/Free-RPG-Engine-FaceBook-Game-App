class AddDefaultValueToAccessTokens < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.change :access_token, :string, :default => "", :null => false
    end
  end

  def self.down
    change_table :users do |t|
      t.change :access_token, :string, :default => nil, :null => false
    end
  end
end
