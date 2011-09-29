class BankOperation < ActiveRecord::Base
  belongs_to :character

  attr_accessible :amount

  validates_presence_of :amount
  validates_numericality_of :amount, :greater_than => 0, :only_integer => true
end
