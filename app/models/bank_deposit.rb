class BankDeposit < BankOperation
  before_create :move_money

  protected

  def validate_on_create
    errors.add(:amount, :not_enough) if amount && amount > character.basic_money
  end

  def move_money
    character.bank += amount - Setting.p(:bank_deposit_fee, amount).floor

    character.charge!(amount, 0, :bank_deposit)
  end
end
