class AddVisitTrackingToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.integer   :signup_ip
      t.integer   :last_visit_ip
      t.datetime  :last_visit_at
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :signup_ip
      t.remove :last_visit_ip
      t.remove :last_visit_at
    end
  end
end
