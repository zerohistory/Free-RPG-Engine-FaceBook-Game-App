class TutorialsController < ApplicationController
  def show
    @current_step = params[:id]

    render :partial => "tutorials/block", :layout => false
  end
end
