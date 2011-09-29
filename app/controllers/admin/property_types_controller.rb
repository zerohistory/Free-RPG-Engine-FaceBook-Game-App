class Admin::PropertyTypesController < Admin::BaseController
  def index
    @types = PropertyType.without_state(:deleted).paginate(:order => :level, :page => params[:page])
  end

  def new
    @type = PropertyType.new

    if params[:property_type]
      @type.attributes = params[:property_type]

      @type.valid?
    end
  end

  def create
    @type = PropertyType.new(params[:property_type])

    if @type.save
      flash[:success] = t(".success")

      unless_continue_editing do
        redirect_to admin_property_types_path
      end
    else
      render :action => :new
    end
  end

  def edit
    @type = PropertyType.find(params[:id])

    if params[:property_type]
      @type.attributes = params[:property_type]

      @type.valid?
    end
  end

  def update
    @type = PropertyType.find(params[:id])

    if @type.update_attributes(params[:property_type].reverse_merge(:payouts => nil, :requirements => nil))
      flash[:success] = t(".success")

      unless_continue_editing do
        redirect_to admin_property_types_path
      end
    else
      render :action => :edit
    end
  end

  def publish
    @type = PropertyType.find(params[:id])

    @type.publish if @type.can_publish?

    redirect_to admin_property_types_path
  end

  def hide
    @type = PropertyType.find(params[:id])

    @type.hide if @type.can_hide?

    redirect_to admin_property_types_path
  end

  def destroy
    @type = PropertyType.find(params[:id])

    @type.mark_deleted if @type.can_mark_deleted?

    redirect_to admin_property_types_path
  end


  def duplicate
    @type = PropertyType.find(params[:id])
    
    @new_type = @type.clone
    @new_type.name += ' (Copy)'
    @new_type.image = @type.image.to_file if @type.image?
    
    PropertyType.transaction do      
      @new_type.save!
    end
    
    redirect_to admin_property_types_path
  end
end
