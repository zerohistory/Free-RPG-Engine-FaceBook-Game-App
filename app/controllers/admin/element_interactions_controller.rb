class Admin::ElementInteractionsController < Admin::BaseController
  def index
    @interactions = ElementInteraction.find(:all)
  end

  def new
    @element_interaction = ElementInteraction.new
  end

  def create
    @element_interaction = ElementInteraction.new(params[:element_interaction])

    if @element_interaction.save
      flash[:success] = t(".success")
      unless_continue_editing do
        redirect_to admin_element_interactions_path
      end
    else
      render :action => :new
    end
  end

  def edit
    @element_interaction = ElementInteraction.find(params[:id])

    if params[:element_interaction]
      @element_interaction = params[:element_interaction]
      @element_interaction.valid?
    end
  end

  def update
    @element_interaction = ElementInteraction.find(params[:id])

    if @element_interaction.update_attributes(params[:element_interaction])
      flash[:success] = t(".success")
      unless_continue_editing do
        redirect_to admin_element_interactions_path
      end
    else
      render :action => :edit
    end
  end

  def destroy
    ElementInteraction.destroy(params[:id])
    redirect_to admin_element_interactions_path
  end
end
