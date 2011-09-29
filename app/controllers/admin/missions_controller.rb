class Admin::MissionsController < Admin::BaseController
  def index
    @missions = Mission.without_state(:deleted).all(
      :include  => :mission_group,
      :order    => "mission_groups.position, mission_groups.id, missions.position"
    )
  end

  def balance
    @character_types = CharacterType.without_state(:deleted)

    @character_type = @character_types.find_by_id(params[:character_type_id]) || @character_types.first

    @missions = Mission.without_state(:deleted).visible_for(@character_type).all(
      :include  => :mission_group,
      :order    => "mission_groups.position"
    )
  end

  def new
    redirect_to new_admin_mission_group_path if MissionGroup.count == 0

    @mission = Mission.new

    if params[:mission]
      @mission.attributes = params[:mission]

      @mission.valid?
    end
  end

  def create
    @mission = Mission.new(params[:mission])

    if @mission.save
      flash[:success] = t(".success")

      unless_continue_editing do
        redirect_to new_polymorphic_path([:admin, @mission, MissionLevel])
      end
    else
      render :action => :new
    end
  end

  def edit
    @mission = Mission.find(params[:id])

    if params[:mission]
      @mission.attributes = params[:mission]

      @mission.valid?
    end
  end

  def update
    @mission = Mission.find(params[:id])

    if @mission.update_attributes(params[:mission].reverse_merge(:requirements => nil, :payouts => nil))
      flash[:success] = t(".success")

      unless_continue_editing do
        redirect_to(
          @mission.levels.size > 0 ? admin_missions_path : new_polymorphic_path([:admin, @mission, MissionLevel])
        )
      end
    else
      render :action => :edit
    end
  end

  def publish
    @mission = Mission.find(params[:id])

    @mission.publish if @mission.can_publish?

    redirect_to admin_missions_path
  end

  def hide
    @mission = Mission.find(params[:id])

    @mission.hide if @mission.can_hide?

    redirect_to admin_missions_path
  end

  def destroy
    @mission = Mission.find(params[:id])

    @mission.mark_deleted if @mission.can_mark_deleted?

    redirect_to admin_missions_path
  end

  def move
    @group = Mission.find(params[:id])

    case params[:direction]
    when "up"
      @group.move_higher
    when "down"
      @group.move_lower
    end

    redirect_to admin_missions_path
  end
  
  def duplicate
    @mission = Mission.find(params[:id])
    
    @new_mission = @mission.clone
    @new_mission.name += ' (Copy)'
    @new_mission.image = @mission.image.to_file if @mission.image?
    
    Mission.transaction do      
      @mission.levels.each do |level|
        @new_mission.levels << level.clone
      end
      
      @new_mission.save!
    end
    
    redirect_to admin_missions_path
  end
end
