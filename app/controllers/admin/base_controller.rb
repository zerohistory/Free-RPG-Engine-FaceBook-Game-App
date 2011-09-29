class Admin::BaseController < ApplicationController
  skip_before_filter :check_character_existance, :check_bookmark_reference

  before_filter :admin_required

  layout "admin/layouts/application"

  protected

  def admin_required
    redirect_from_iframe root_url(:canvas => true) unless current_user.admin?
  end

  def ajax_layout
    "admin/layouts/ajax"
  end

  def unless_continue_editing(options = {}, &block)
    if params[:continue]
      render options.reverse_merge(:action => :edit)
    else
      yield
    end
  end

  def t(*args)
    key = args.shift

    super(
      *(
        [key.starts_with?(".") ? "admin.#{controller_name}.#{action_name}#{key}" : key] + args
      )
    )
  end
end
