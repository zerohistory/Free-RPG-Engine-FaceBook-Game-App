class Admin::SettingsController < Admin::BaseController
  def index
    @settings = Setting.all(:order => :alias)
  end

  def new
    @setting = Setting.new

    render :new_payout if params["type"] == "payout"
  end

  def create
    @setting = Setting.new(params[:setting])

    if @setting.save
      flash[:success] = t(".success")

      unless_continue_editing do
        redirect_to admin_settings_path
      end
    else
      unless @setting.payout?
        render :action => :new
      else
        render :action => :new_payout
      end
    end
  end

  def edit
    @setting = Setting.find(params[:id])

    if @setting.payout?
      render :edit_payout
    end
  end

  def update
    @setting = Setting.find(params[:id])

    if @setting.update_attributes(params[:setting])
      flash[:success] = t(".success")

      unless_continue_editing do
        redirect_to admin_settings_path
      end
    else
      unless @setting.payout?
        render :action => :edit
      else
        render :action => :edit_payout
      end
    end
  end

  def destroy
    @setting = Setting.find(params[:id])

    @setting.destroy

    redirect_to admin_settings_path
  end
end
