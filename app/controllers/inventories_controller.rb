class InventoriesController < ApplicationController
  before_filter :check_auto_equipment, :only => [:equipment, :equip, :unequip]

  def new
    @item = Item.available.available_in(:shop, :special).available_for(current_character).find_by_id(params[:item_id])
    @amount = params[:amount].to_i

    render :action => :new, :layout => "ajax"
  end

  def create
    @item = Item.available.available_in(:shop, :special).available_for(current_character).find(params[:item_id])

    @inventory = current_character.inventories.buy!(@item, params[:amount].to_i)

    @amount = params[:amount].to_i * @item.package_size

    render :action => :create, :layout => "ajax"
  end

  def destroy
    @amount = params[:amount].to_i

    @item = Item.find(params[:id])

    @inventory = current_character.inventories.sell!(@item, @amount)

    render :action => :destroy, :layout => "ajax"
  end

  def index
    @inventories = current_character.inventories
  end

  def use
    @inventory = current_character.inventories.find(params[:id])

    @result = @inventory.use!(current_character)
  #~ @result=nil
    render :action => :use, :layout => "ajax"
  end

  def gift
    case request.method
    when :get
      @inventory = Inventory.find(params[:id])

      @amount = params[:amount].to_i
      @amount = @inventory.amount if @amount > @inventory.amount

      @cost = @amount * @inventory.item.gift_cost
      @can_make_gift = current_character.vip_money >= @cost

      render :action => :gift, :layout => "ajax"
    when :post
      inventory = Inventory.find(params[:id])
      if params[:relation_id] && !params[:relation_id].empty?
        relation = FriendRelation.find(params[:relation_id])
        current_character.gift!(inventory, relation.character, params[:amount].to_i, params[:cost].to_i) if relation
      end

      redirect_to inventories_path
    end
  end

  def equipment

  end

  def equip
    if params[:id]
      @inventory = current_character.inventories.find(params[:id])

      current_character.equipment.equip!(@inventory, params[:placement])
    else
      current_character.equipment.equip_best!
    end

    render :layout => "ajax"
  end

  def unequip
    if params[:id]
      @inventory = current_character.inventories.find(params[:id])

      current_character.equipment.unequip!(@inventory, params[:placement])
    else
      current_character.equipment.unequip_all!
    end

    render :action => "equip", :layout => "ajax"
  end

  def give
    data = encryptor.decrypt(params[:request_data].to_s)

    if Time.now < data[:valid_till]
      @character = Character.find(data[:character_id])

      if @character == current_character
        redirect_from_iframe root_url(:canvas => true)
      elsif request.get?
        @inventories = current_character.inventories.find_all_by_item_id(data[:items])

        if @inventories.empty?
          flash[:error] = t('inventories.give.messages.no_items')

          redirect_from_iframe root_url(:canvas => true)
        end
      else
        @inventories = current_character.inventories.all(
          :conditions => {
            :item_id => data[:items],
            :id => params[:inventory].keys
          }
        )

        @inventories.each do |inventory|
          if amount = params[:inventory][inventory.id.to_s].to_i and amount > 0
            current_character.inventories.transfer!(@character, inventory, amount)
          end
        end

        # TODO Refactor this to use AJAX instead of redirects
        flash[:success] = t('inventories.give.messages.success')

        redirect_from_iframe root_url(:canvas => true)
      end
    else
      flash[:error] = t('inventories.give.messages.expired')

      redirect_from_iframe root_url(:canvas => true)
    end
  rescue ActiveSupport::MessageEncryptor::InvalidMessage
    Rails.logger.error "Failed to decrypt collection request data: #{params[:request_data]}"
    
    redirect_from_exception
  end

  protected

  def check_auto_equipment
    redirect_from_iframe inventories_url(:canvas => true) if Setting.b(:character_auto_equipment)
  end
end
