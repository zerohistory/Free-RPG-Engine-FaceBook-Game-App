class Admin::HelpPagesController < Admin::BaseController
  def index
    @pages = HelpPage.all(:order => :alias)
  end

  def new
    @page = HelpPage.new(params[:help_page])
  end

  def create
    @page = HelpPage.new(params[:help_page])

    if @page.save
      flash[:success] = t(".success")

      unless_continue_editing do
        redirect_to admin_help_pages_path
      end
    else
      render :action => :new
    end
  end

  def edit
    @page = HelpPage.find(params[:id])
  end

  def update
    @page = HelpPage.find(params[:id])

    if @page.update_attributes(params[:help_page])
      flash[:success] = t(".success")

      unless_continue_editing do
        redirect_to admin_help_pages_path
      end
    else
      render :action => :edit
    end
  end

  def publish
    @page = HelpPage.find(params[:id])

    @page.publish if @page.can_publish?

    redirect_to admin_help_pages_path
  end

  def hide
    @page = HelpPage.find(params[:id])

    @page.hide if @page.can_hide?

    redirect_to admin_help_pages_path
  end

  def destroy
    @page = HelpPage.find(params[:id])

    @page.mark_deleted if @page.can_mark_deleted?

    redirect_to admin_help_pages_path
  end
end
