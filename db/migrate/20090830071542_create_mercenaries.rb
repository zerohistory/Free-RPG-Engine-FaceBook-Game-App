class CreateMercenaries < ActiveRecord::Migration
  def self.up
    add_column :relations, :type, :string
    add_column :relations, :name, :string
  end

  def self.down
    remove_column :relations, :type
    remove_column :relations, :name
  end
end
