class PromotionsController < ApplicationController
  def show
    id, secret = params[:id].split("-")

    @promotion = Promotion.find(id)

    if current_user.admin? or @promotion.can_be_received?(current_character, secret)
      @result = @promotion.promotion_receipts.create(:character => current_character)
    else
      if @promotion.expired?
        flash[:notice] = t("promotions.show.expired")
      else
        flash[:notice] = t("promotions.show.already_used")
      end

      redirect_from_iframe root_url(:canvas => true)
    end
  end
end
