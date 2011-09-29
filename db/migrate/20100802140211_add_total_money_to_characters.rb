class AddTotalMoneyToCharacters < ActiveRecord::Migration
  def self.up
    change_table :characters do |t|
      t.integer :total_money, :default => 0
    end
    
    Rake::Task["app:maintenance:update_total_money_for_characters"].execute
  end

  def self.down
    change_table :characters do |t|
      t.remove :total_money
    end
  end
end
