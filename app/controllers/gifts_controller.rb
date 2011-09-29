class GiftsController < ApplicationController
  def new
    @items = Item.gifts_for(current_character).all(
      :limit => Setting.i(:gifting_item_show_limit)
    )

    redirect_from_iframe root_url(:canvas => true) if @items.empty?
  end
end
