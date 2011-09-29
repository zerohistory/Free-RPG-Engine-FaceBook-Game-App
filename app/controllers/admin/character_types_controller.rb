class Admin::CharacterTypesController < Admin::BaseController
  def index
    @character_types = CharacterType.without_state(:deleted)
  end

  def new
    @character_type = CharacterType.new

    if params[:character_type]
      @character_type.attributes = params[:character_type]

      @character_type.valid?
    end
  end

  def create
    @character_type = CharacterType.new(params[:character_type])

    if @character_type.save
      flash[:success] = t(".success")

      unless_cotinue_editing do
        redirect_to admin_character_types_path
      end
    else
      render :action => :new
    end
  end

  def edit
    @character_type = CharacterType.find(params[:id])

    if params[:character_type]
      @character_type.attributes = params[:character_type]

      @character_type.valid?
    end
  end

  def update
    @character_type = CharacterType.find(params[:id])

    if @character_type.update_attributes(params[:character_type])
      flash[:success] = t(".success")

      unless_continue_editing do
        redirect_to admin_character_types_path
      end
    else
      render :action => :edit
    end
  end

  def publish
    @character_type = CharacterType.find(params[:id])

    @character_type.publish if @character_type.can_publish?

    redirect_to admin_character_types_path
  end

  def hide
    @character_type = CharacterType.find(params[:id])

    @character_type.hide if @character_type.can_hide?

    redirect_to admin_character_types_path
  end

  def destroy
    @character_type = CharacterType.find(params[:id])

    @character_type.mark_deleted if @character_type.can_mark_deleted?

    redirect_to admin_character_types_path
  end
end
