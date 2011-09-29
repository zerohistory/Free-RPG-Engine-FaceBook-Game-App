class Admin::TipsController < Admin::BaseController
  def index
    @tips = Tip.without_state(:deleted).paginate(:page => params[:page])
  end

  def new
    @tip = Tip.new
  end

  def create
    @tip = Tip.new(params[:tip])

    if @tip.save
      flash[:success] = t(".success")

      unless_continue_editing do
        redirect_to admin_tips_path
      end
    else
      render :action => :new
    end
  end

  def edit
    @tip = Tip.find(params[:id])
  end

  def update
    @tip = Tip.find(params[:id])

    if @tip.update_attributes(params[:tip])
      flash[:success] = t(".success")

      unless_continue_editing do
        redirect_to admin_tips_path
      end
    else
      render :action => :edit
    end
  end

  def publish
    @tip = Tip.find(params[:id])

    @tip.publish if @tip.can_publish?

    redirect_to admin_tips_path
  end

  def hide
    @tip = Tip.find(params[:id])

    @tip.hide if @tip.can_hide?

    redirect_to admin_tips_path
  end

  def destroy
    @tip = Tip.find(params[:id])

    @tip.mark_deleted

    redirect_to admin_tips_path
  end
end
