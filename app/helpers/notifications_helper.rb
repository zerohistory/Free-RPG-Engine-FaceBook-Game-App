module NotificationsHelper
  def display_notifications
    if notifications = current_character.notifications.with_state(:pending).all and notifications.any?
      Notification::Base.transaction do
        notifications.each do |n|
          n.display
        end
      end

      notifications.collect do |notification|
        render("notifications/#{notification.class_to_type}", :notification => notification)
      end.join.html_safe
    end
  end
end
