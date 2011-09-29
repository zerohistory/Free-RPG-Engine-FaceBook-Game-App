class Admin::ItemElementsController < Admin::BaseController
  def index
    if params["item_id"]
      @item = Item.find(params["item_id"])
      @item_elements = ItemElement.find(:all, :conditions => ["item_id = ?", params["item_id"]])
    else
      @item_elements = ItemElement.all
    end
  end

  def create
    @item_element = ItemElement.new(params[:item_element])
    @item_element.save

    respond_to do |f|
      f.html { redirect_to root_path }
      f.js { 
        item_elements = ItemElement.find(:all, :conditions => ["item_id = ?", @item_element.item_id])
        render :partial => "item_elements", :locals => {:item_elements => item_elements, :item => Item.find(@item_element.item_id)}
      }
    end
  end

  def destroy
    ItemElement.destroy(params[:id])

    respond_to do |f|
      f.html { redirect_to root_path }
      f.js { 
        item_elements = params["item_id"] ? ItemElement.find(:all, :conditions => ["item_id = ?", params["item_id"]]) : ItemElement.all
        render :partial => "item_elements", :locals => {:item_elements => item_elements, :item => Item.find(params["item_id"])}
      }
    end
  end
end
