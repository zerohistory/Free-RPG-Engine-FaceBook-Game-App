class Admin::StatisticsController < Admin::BaseController
  def index
    @statistics = Statistics::Dashboard.new(24.hours.ago)
  end

  def user
    @statistics = Statistics::Users.new(24.hours.ago)
  end

  def vip_money
    @statistics = Statistics::VipMoney.new(24.hours.ago)
  end
end
