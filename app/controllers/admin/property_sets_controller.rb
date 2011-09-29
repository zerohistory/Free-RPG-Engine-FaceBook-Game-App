class Admin::PropertySetsController < Admin::BaseController
  def index
    @property_sets = PropertySet.all(:order => "name ASC")
  end

  def new
    @property_set = PropertySet.new
  end

  def add_property
    @property = PropertyType.new
  end

  def create
    @property_set = PropertySet.new(params[:property_set])

    if @property_set.save
      flash[:success] = t(".success")

      unless_continue_editing do
        redirect_to admin_property_sets_path
      end
    else
      render :action => :new
    end
  end

  def edit
    @property_set = PropertySet.find(params[:id])
  end

  def update
    @property_set = PropertySet.find(params[:id])

    if @property_set.update_attributes(params[:property_set].reverse_merge(:properties => nil))
      flash[:success] = t(".success")

      unless_continue_editing do
        redirect_to admin_property_sets_path
      end
    else
      render :action => :edit
    end
  end


  def duplicate
    @set = PropertySet.find(params[:id])
    
    @new_set = @set.clone
    @new_set.name += ' (Copy)'
    
    PropertyType.transaction do      
      @new_set.save!
    end
    
    redirect_to admin_property_sets_path
  end
end
