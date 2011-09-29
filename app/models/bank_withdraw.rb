class BankWithdraw < BankOperation
  before_create :move_money

  protected

  def validate_on_create
    errors.add(:amount, :not_enough) if amount && amount > character.bank
  end

  def move_money
    character.bank -= amount

    character.charge!(- amount, 0, :bank_withdraw)
  end
end
