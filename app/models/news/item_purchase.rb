module News
  class ItemPurchase < Base
    def item
      @item || find_item
    end

    def amount
      data[:amount]
    end

    protected

    def find_item
      @item = Item.find(data[:item_id])
    end
  end
end
