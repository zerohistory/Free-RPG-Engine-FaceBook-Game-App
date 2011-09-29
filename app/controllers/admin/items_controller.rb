class Admin::ItemsController < Admin::BaseController
  def index
    @availability = params[:availability].try(:to_sym)
    @item_group = ItemGroup.find_by_id(params[:item_group_id])

    @scope = @item_group ? @item_group.items : Item
    @scope = @scope.available_in(@availability)

    @items = @scope.without_state(:deleted).scoped(
      :include  => :item_group,
      :order    => "item_groups.position, items.availability, items.level"
    ).paginate(:page => params[:page])
  end

  def new
    redirect_to new_admin_item_group_path if ItemGroup.count == 0

    @item = Item.new
    @item.placements = Character::Equipment::DEFAULT_PLACEMENTS

    if params[:item]
      @item.attributes = params[:item]

      @item.valid?
    end
  end

  def create
    @item = Item.new(params[:item])

    if @item.save
      flash[:success] = t(".success")

      unless_continue_editing do
        redirect_to admin_items_path
      end
    else
      render :action => :new
    end
  end

  def edit
    @item = Item.find(params[:id])

    if params[:item]
      @item.attributes = params[:item]

      @item.valid?
    end
  end

  def update
    @item = Item.find(params[:id])

    if @item.update_attributes(params[:item].reverse_merge(:payouts => nil, :placements => nil, :requirements => nil))
      flash[:success] = t(".success")

      unless_continue_editing do
        redirect_to admin_items_path
      end
    else
      render :action => :edit
    end
  end

  def publish
    @item = Item.find(params[:id])

    @item.publish if @item.can_publish?

    redirect_to admin_items_path
  end

  def hide
    @item = Item.find(params[:id])

    @item.hide if @item.can_hide?

    redirect_to admin_items_path
  end

  def destroy
    @item = Item.find(params[:id])

    @item.mark_deleted if @item.can_mark_deleted?

    redirect_to admin_items_path
  end

  def balance
    @items = ActiveSupport::OrderedHash.new

    @item_group = ItemGroup.find_by_id(params[:item_group_id])

    items = (@item_group ? @item_group.items : Item).with_state(:visible).all(:order => "level, availability, item_group_id")
    items.each do |item|
      @items[item.level] ||= ActiveSupport::OrderedHash.new
      @items[item.level][item.availability] ||= []

      @items[item.level][item.availability] << item
    end
  end
  
  
  def duplicate
    @item = Item.find(params[:id])
    
    @new_item = @item.clone
    @new_item.name += ' (Copy)'
    @new_item.image = @item.image.to_file if @item.image?
    
    Item.transaction do      
      @new_item.save!
    end
    
    redirect_to admin_items_path
  end
end
