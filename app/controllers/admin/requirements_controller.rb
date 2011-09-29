class Admin::RequirementsController < Admin::BaseController
  def new
    @container    = params[:container]
    @requirement  = Requirements::Base.by_name(params[:type]).new

    render :layout => :ajax_layout
  end
end
