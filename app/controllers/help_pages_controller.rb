class HelpPagesController < ApplicationController
  skip_before_filter :check_character_existance, :ensure_canvas_connected_to_facebook

  def show
    @page = HelpPage.find_by_alias(params[:id]) or raise ActiveRecord::RecordNotFound

    respond_to do |format|
      format.js { render :layout => false }
      format.html
    end
  end
end
