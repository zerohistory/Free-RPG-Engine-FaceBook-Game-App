class Admin::ElementsController < Admin::BaseController
  def index
    @elements = Element.find(:all)
  end

  def new
    @element = Element.new

    if params[:element]
      @element.attributes = params[:element]
      @element.valid?
    end
  end

  def create
    @element = Element.new(params[:element])

    if @element.save
      flash[:success] = t(".success")
      unless_continue_editing do
        redirect_to admin_elements_path
      end
    else
      render :action => :new
    end
  end

  def edit
    @element = Element.find(params[:id])

    if params[:element]
      @element.attributes = params[:element]
      @element.valid?
    end
  end

  def update
    @element = Element.find(params[:id])

    if @element.update_attributes(params[:element])
      flash[:success] = t(".success")
      unless_continue_editing do
        redirect_to admin_elements_path
      end
    else
      render :action => :edit
    end
  end

  def destroy
    Element.destroy(params[:id])
    redirect_to admin_elements_path
  end
end
