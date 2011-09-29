class PromotionReceipt < ActiveRecord::Base
  belongs_to :promotion, :counter_cache => true
  belongs_to :character

  before_create :assign_payouts

  attr_reader :payouts

  protected

  def assign_payouts
    @payouts = promotion.payouts.apply(character, :success, promotion)

    character.save!
  end
end
