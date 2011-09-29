class IncreseSizeOfPromotionText < ActiveRecord::Migration
  def self.up
    change_column :promotions, :text, :text
  end

  def self.down
    change_column :promotions, :text, :string
  end
end
