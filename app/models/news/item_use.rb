module News
  class ItemUse < Base
    def item
      @item ||= Item.find(data[:item_id]) if !data[:item_id].blank?
    end
  end
end
