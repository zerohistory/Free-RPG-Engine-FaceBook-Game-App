class MakeTotalMoneyBigint < ActiveRecord::Migration
  def self.up
    change_table :characters do |t|
      t.change :total_money, :bigint, :default => 0
    end
    
    Character.update_all "total_money = basic_money + bank"
  end

  def self.down
    change_table :characters do |t|
      t.change :total_money, :integer, :default => 0
    end
  end
end
