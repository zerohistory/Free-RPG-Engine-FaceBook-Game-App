class NotificationsController < ApplicationController
  def disable
    @notification = current_character.notifications.find(params[:id])

    @notification.disable

    render :text => "<!-- no data -->"
  end
end
