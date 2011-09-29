class PremiaController < ApplicationController
  skip_before_filter :check_character_health

  def show
    @special_items = Item.special_for(current_character).all(:limit => 3, :order => 'created_at DESC')
  end

  def update
    @result =
      case params[:type].to_sym
      when :buy_points
        current_character.buy_points!
      when :exchange_money
        current_character.exchange_money!
      when :refill_energy
        current_character.refill_energy!
      when :refill_health
        current_character.refill_health!
      when :refill_stamina
        current_character.refill_stamina!
      when :hire_mercenary
        current_character.hire_mercenary!
      when :reset_attributes
        current_character.reset_attributes!
      when :change_name
        if current_character.change_name!
          flash[:premium_change_name] = true

          @redirect_to = edit_character_path(:current)
        end
      when :reset_character
        current_character.destroy
        @redirect_to = root_path
      else
        false
      end

    if @result
      flash.now[:success] = t("premia.update.messages.success.#{params[:type]}")
    else
      flash.now[:error] = t("premia.update.messages.failure")
    end

    render :layout => 'ajax'
  end
end
