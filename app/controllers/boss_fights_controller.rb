class BossFightsController < ApplicationController
  def create
    unless @fight
      boss = Boss.find(params[:boss_id])

      @fight = current_character.boss_fights.find_by_boss(boss)
    end

    @fight.perform!

    render :action => :create, :layout => "ajax"
  end

  def update
    @fight = current_character.boss_fights.find(params[:id])

    create
  end
end
