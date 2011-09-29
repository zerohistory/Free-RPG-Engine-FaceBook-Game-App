class Admin::ItemSetsController < Admin::BaseController
  def index
    @item_sets = ItemSet.all(:order => "name ASC")
  end

  def new
    @item_set = ItemSet.new
  end

  def add_item
    @item = Item.new
  end

  def create
    @item_set = ItemSet.new(params[:item_set])

    if @item_set.save
      flash[:success] = t(".success")

      unless_continue_editing do
        redirect_to admin_item_sets_path
      end
    else
      render :action => :new
    end
  end

  def edit
    @item_set = ItemSet.find(params[:id])
  end

  def update
    @item_set = ItemSet.find(params[:id])

    if @item_set.update_attributes(params[:item_set].reverse_merge(:items => nil))
      flash[:success] = t(".success")

      unless_continue_editing do
        redirect_to admin_item_sets_path
      end
    else
      render :action => :edit
    end
  end
end
