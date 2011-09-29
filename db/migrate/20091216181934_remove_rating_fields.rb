class RemoveRatingFields < ActiveRecord::Migration
  def self.up
    change_table :characters do |t|
      t.remove :rating
    end

    change_table :configurations do |t|
      t.remove  "rating_missions_completed"
      t.remove  "rating_relations"
      t.remove  "rating_fights_won"
      t.remove  "rating_missions_succeeded"
      t.remove  "rating_income_divider"
      t.remove  "rating_income_ceil"
    end
  end

  def self.down
    change_table :characters do |t|
      t.integer :rating, :default => 0
    end

    change_table :configurations do |t|
      t.integer  "rating_missions_completed",              :default => 500
      t.integer  "rating_relations",                       :default => 100
      t.integer  "rating_fights_won",                      :default => 10
      t.integer  "rating_missions_succeeded",              :default => 5
      t.integer  "rating_income_divider",                  :default => 5
      t.integer  "rating_income_ceil",                     :default => 50000
    end
  end
end
