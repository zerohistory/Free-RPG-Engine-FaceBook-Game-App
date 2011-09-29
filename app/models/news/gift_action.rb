module News
  class GiftAction < Base
    def action
      data[:action]
    end

    def item
      @item || find_item
    end

    def sender
      @sender || find_sender
    end
    
    def receiver
      @receiver || find_receiver
    end

    def amount
      data[:amount]
    end

  protected
    def find_item
      @item = Item.find(data[:item_id])
    end

    def find_sender
      @sender = Character.find(data[:sender_id])
    end

    def find_receiver
      @receiver = Character.find(data[:receiver_id])
    end
  end
end
