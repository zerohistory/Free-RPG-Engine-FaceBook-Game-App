class AllowNullForCharacterName < ActiveRecord::Migration
  def self.up
    change_column :characters, :name, :string, :limit => 100, :default => "", :null => true
  end

  def self.down
    change_column :characters, :name, :string, :limit => 100, :default => "", :null => false
  end
end
