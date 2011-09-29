class AddForwardableToPromotions < ActiveRecord::Migration
  def self.up
    add_column :promotions, :forwardable, :boolean
  end

  def self.down
    remove_column :promotions, :forwardable
  end
end
