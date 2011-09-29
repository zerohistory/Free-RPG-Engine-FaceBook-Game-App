class AddRatingToCharacters < ActiveRecord::Migration
  def self.up
    add_column :characters, :rating, :integer, :default => 0
  end

  def self.down
    remove_column :characters, :rating
  end
end
