class Admin::GlobalTasksController < Admin::BaseController
  helper_method :delete_user_limit

  def delete_users
    if User.count < delete_user_limit
      User.destroy_all
    else
      flash[:error] = t(".user_limit_reached", :limit => delete_user_limit)
    end

    redirect_to admin_global_task_path
  end

  def restart
    Rails.restart!

    flash[:success] = t(".success")

    redirect_to admin_global_task_path
  end

  protected

  def delete_user_limit
    100
  end
end
