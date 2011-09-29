class VipMoneyOperationsController < ApplicationController
  skip_before_filter :check_character_existance, :ensure_canvas_connected_to_facebook

  def load_money
    on_valid_facebook_money_request do |user_id, amount|
      Character.find(user_id).charge!(0, - amount, FacebookMoney.config["provider"])
    end
  end
end
