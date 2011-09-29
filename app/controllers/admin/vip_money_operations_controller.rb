class Admin::VipMoneyOperationsController < Admin::BaseController
  helper_method :operation_type, :operation_class

  def index
    scope = operation_class
    scope = scope.by_reference_type(params[:reference_type]) unless params[:reference_type].blank?
    scope = scope.by_profile_ids(params[:profile_ids].split(/[^\d]+/)) unless params[:profile_ids].blank?

    @operations = scope.latest.paginate(:page => params[:page], :per_page => 100)
  end

  protected

  def operation_type
    params[:type] == "withdrawal" ? "withdrawal" : "deposit"
  end

  def operation_class
    "VipMoney#{operation_type.classify}".constantize
  end
end
