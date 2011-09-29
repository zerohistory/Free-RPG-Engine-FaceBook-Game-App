class AddInvitePromotionToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :invite_page_visited_at, :datetime
  end

  def self.down
    remove_column :users, :invite_page_visited_at
  end
end
