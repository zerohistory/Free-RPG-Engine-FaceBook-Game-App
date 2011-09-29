class Admin::AssetsController < Admin::BaseController
  def index
    @assets = Asset.paginate(:order => :alias, :page => params[:page], :per_page => 100)
  end

  def new
    @asset = Asset.new

    if params[:asset]
      @asset.attributes = params[:asset]

      @asset.valid?
    end
  end

  def create
    @asset = Asset.new(params[:asset])

    if @asset.save
      update_stylesheets

      flash[:success] = t(".success")

      unless_continue_editing do
        redirect_to admin_assets_path
      end
    else
      render :action => :new
    end
  end

  def edit
    @asset = Asset.find(params[:id])

    if params[:asset]
      @asset.attributes = params[:asset]

      @asset.valid?
    end
  end

  def update
    @asset = Asset.find(params[:id])

    if @asset.update_attributes(params[:asset])
      update_stylesheets

      flash[:success] = t(".success")

      unless_continue_editing do
        redirect_to admin_assets_path
      end
    else
      render :action => :edit
    end
  end

  def destroy
    @asset = Asset.find(params[:id])

    @asset.destroy

    update_stylesheets

    redirect_to admin_assets_path
  end

  protected

  def update_stylesheets
    Asset.update_sass

    Sass::Plugin.update_stylesheets
  end
end
