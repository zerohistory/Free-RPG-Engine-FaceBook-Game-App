class VipMoneyWithdrawal < VipMoneyOperation
  after_create :withdraw_money

  protected

  def validate_on_create
    errors.add(:amount, :not_enough) if amount && amount > character.vip_money
  end

  def withdraw_money
    character.vip_money -= amount

    character.save!
  end
end
