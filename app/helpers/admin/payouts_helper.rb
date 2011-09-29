module Admin::PayoutsHelper
  def admin_payouts_preview(payouts)
    result = ""

    payouts.each do |payout|
      result << render("admin/payouts/preview/#{payout.name}", :payout => payout)
    end

    result.html_safe
  end
end
