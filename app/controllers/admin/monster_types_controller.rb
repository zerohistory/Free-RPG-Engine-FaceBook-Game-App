class Admin::MonsterTypesController < Admin::BaseController
  def index
    @types = MonsterType.without_state(:deleted)
  end

  def new
    @monster_type = MonsterType.new
  end

  def create
    @monster_type = MonsterType.new(params[:monster_type])

    if @monster_type.save
      flash[:success] = t(".success")

      unless_continue_editing do
        redirect_to admin_monster_types_path
      end
    else
      render :action => :new
    end
  end

  def edit
    @monster_type = MonsterType.find(params[:id])
  end

  def update
    @monster_type = MonsterType.find(params[:id])

    if @monster_type.update_attributes(params[:monster_type].reverse_merge(:requirements => nil, :payouts => nil))
      flash[:success] = t(".success")

      unless_continue_editing do
        redirect_to admin_monster_types_path
      end
    else
      render :action => :edit
    end
  end

  def publish
    @monster_type = MonsterType.find(params[:id])

    @monster_type.publish if @monster_type.can_publish?

    redirect_to admin_monster_types_path
  end

  def hide
    @monster_type = MonsterType.find(params[:id])

    @monster_type.hide if @monster_type.can_hide?

    redirect_to admin_monster_types_path
  end

  def destroy
    @monster_type = MonsterType.find(params[:id])

    @monster_type.mark_deleted if @monster_type.can_mark_deleted?

    redirect_to admin_monster_types_path
  end
end
