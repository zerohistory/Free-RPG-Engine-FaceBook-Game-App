class ChangeBasicMoneyType < ActiveRecord::Migration
  def self.up
    change_column :bank_operations, :amount,      :bigint

    change_column :characters, :basic_money,      :bigint
    change_column :characters, :bank,             :bigint
    change_column :characters, :property_income,  :bigint

    change_column :help_requests, :money,         :bigint

    change_column :items, :basic_price,           :bigint

    change_column :missions, :money_min,          :bigint
    change_column :missions, :money_max,          :bigint
    
    change_column :property_types, :basic_price,  :bigint
  end

  def self.down
  end
end
