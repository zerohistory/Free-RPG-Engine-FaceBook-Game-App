class Admin::BossesController < Admin::BaseController
  def index
    @bosses = Boss.without_state(:deleted).paginate(:page => params[:page])
  end

  def new
    redirect_to new_admin_boss_group_path if MissionGroup.count == 0

    @boss = Boss.new

    if params[:boss]
      @boss.attributes = params[:boss]

      @boss.valid?
    end
  end

  def create
    @boss = Boss.new(params[:boss])

    if @boss.save
      flash[:success] = t(".success")

      unless_continue_editing do
        redirect_to admin_bosses_path
      end
    else
      render :action => :new
    end
  end

  def edit
    @boss = Boss.find(params[:id])

    if params[:boss]
      @boss.attributes = params[:boss]

      @boss.valid?
    end
  end

  def update
    @boss = Boss.find(params[:id])

    if @boss.update_attributes(params[:boss].reverse_merge(:requirements => nil, :payouts => nil))
      flash[:success] = t(".success")

      unless_continue_editing do
        redirect_to admin_bosses_path
      end
    else
      render :action => :edit
    end
  end

  def publish
    @boss = Boss.find(params[:id])

    @boss.publish if @boss.can_publish?

    redirect_to admin_bosses_path
  end

  def hide
    @boss = Boss.find(params[:id])

    @boss.hide if @boss.can_hide?

    redirect_to admin_bosses_path
  end

  def destroy
    @boss = Boss.find(params[:id])

    @boss.mark_deleted if @boss.can_mark_deleted?

    redirect_to admin_bosses_path
  end
end
