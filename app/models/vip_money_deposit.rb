class VipMoneyDeposit < VipMoneyOperation
  after_create :deposit_money

  protected

  def deposit_money
    character.vip_money += amount

    character.save
  end
end
