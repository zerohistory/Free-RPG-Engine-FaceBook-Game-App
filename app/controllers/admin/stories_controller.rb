class Admin::StoriesController < Admin::BaseController
  def index
    @stories = Story.all(:order => "alias")
  end

  def new
    @story = Story.new
  end

  def create
    @story = Story.new(params[:story])

    if @story.save
      flash[:success] = t(".success")

      unless_continue_editing do
        redirect_to admin_stories_path
      end
    else
      render :action => :new
    end
  end

  def edit
    @story = Story.find(params[:id])
  end

  def update
    @story = Story.find(params[:id])

    if @story.update_attributes(params[:story])
      flash[:success] = t(".success")

      unless_continue_editing do
        redirect_to admin_stories_path
      end
    else
      render :action => :edit
    end
  end

  def publish
    @story = Story.find(params[:id])

    @story.publish if @story.can_publish?

    redirect_to admin_stories_path
  end

  def hide
    @story = Story.find(params[:id])

    @story.hide if @story.can_hide?

    redirect_to admin_stories_path
  end

  def destroy
    @story = Story.find(params[:id])

    @story.mark_deleted

    redirect_to admin_stories_path
  end
end
