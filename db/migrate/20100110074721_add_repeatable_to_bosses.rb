class AddRepeatableToBosses < ActiveRecord::Migration
  def self.up
    change_table :bosses do |t|
      t.boolean :repeatable
    end
  end

  def self.down
    change_table :bosses do |t|
      t.remove :repeatable
    end
  end
end
