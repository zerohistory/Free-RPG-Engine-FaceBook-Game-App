class MarketItemsController < ApplicationController
  def index
    @items = MarketItem.paginate(:page => params[:page])
  end

  def new
    @inventory = current_character.inventories.find_by_id(params[:inventory_id])
    @item = @inventory.build_market_item

    render :layout => "ajax"
  end

  def create
    @inventory = current_character.inventories.find_by_id(params[:market_item][:inventory_id])

    @item = @inventory.build_market_item(params[:market_item])

    if @item.save
      render :create, :layout => "ajax"
    else
      render :new, :layout => "ajax"
    end
  end

  def buy
    @item = MarketItem.find(params[:id])

    @item.buy!(current_character)

    render :buy, :layout => "ajax"
  end

  def destroy
    @item = current_character.market_items.find(params[:id])

    @item.destroy

    render :destroy, :layout => "ajax"
  end
end
