class CouponMailer < ApplicationMailer

  def send_coupon_email(coupon_id)
    @coupon = Coupon.find_by(id: coupon_id)
    @order = @coupon.line_item.order
    if @order
      mail to: @order.user.email, subject: t('.coupon_email_subject')
    end
  end

end
