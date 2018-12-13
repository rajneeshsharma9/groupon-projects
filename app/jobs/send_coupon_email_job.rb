class SendCouponEmailJob < ActiveJob::Base

  def perform(coupon_id)
    CouponMailer.send_coupon_email(coupon_id).deliver_now
  end

end
