module Notification
  class MarketItemSold < Base
    def item
      @item ||= ::Item.find_by_id(data[:item_id])
    end

    def basic_money
      data[:basic_money].to_i
    end

    def vip_money
      data[:vip_money].to_i
    end

    def payouts?
      basic_money > 0 or vip_money > 0
    end
  end
end
