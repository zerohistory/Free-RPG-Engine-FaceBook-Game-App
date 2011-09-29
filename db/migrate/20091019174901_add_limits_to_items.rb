class AddLimitsToItems < ActiveRecord::Migration
  def self.up
    change_table :items do |t|
      t.integer   :owned

      t.integer   :limit
      t.datetime  :available_till
    end
  end

  def self.down
    change_table :items do |t|
      t.remove  :owned

      t.remove  :limit
      t.remove  :available_till
    end
  end
end
