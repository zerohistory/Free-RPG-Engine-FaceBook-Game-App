module TutorialsHelper
  def tutorial_step(controller, action)
    current = (controller_name == controller && action_name == action) || (@current_step == "#{controller}-#{action}")

    reload_function = remote_function(
      :url    => tutorial_path("#{controller}-#{action}"),
      :method => :get,
      :update => :tutorial_container
    )

    yield(current, reload_function)
  end
end
