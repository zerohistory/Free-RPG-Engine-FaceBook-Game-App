class AddLandingTimestampToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.datetime  :landing_visited_at
      t.string    :last_landing

      t.remove :invite_page_visited_at
      t.remove :gift_page_visited_at
    end

    User.update_all ["landing_visited_at = ?", Time.now]
  end

  def self.down
    change_table :users do |t|
      t.remove :landing_visited_at
      t.remove :last_landing

      t.datetime :invite_page_visited_at
      t.datetime :gift_page_visited_at
    end

    User.update_all ["invite_page_visited_at = :time, gift_page_visited_at = :time", {:time => Time.now}]
  end
end
