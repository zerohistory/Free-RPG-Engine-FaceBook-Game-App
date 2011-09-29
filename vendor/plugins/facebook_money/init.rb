require "facebook_money"

ActionController::Base.send(:include, FacebookMoney::ControllerMethods)
ActionView::Base.send(:include, FacebookMoney::HelperMethods)