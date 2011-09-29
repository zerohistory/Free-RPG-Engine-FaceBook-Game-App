class Statistics
  class Dashboard < self
    attr_reader :users, :vip_money

    delegate :total_users, :users_by_period, :to => :users
    delegate :total_deposit, :total_withdrawal, :deposit_by_period, :withdrawal_by_period, :to => :vip_money

    def initialize(*args)
      super(*args)

      @users = Users.new(@time_range)
      @vip_money = VipMoney.new(@time_range)
    end
  end
end
