class OrderMailer < ApplicationMailer

  def send_order_confirmation_email(order_id)
    @order = Order.find_by(id: order_id)
    if @order
      mail to: @order.user.email, subject: t('.order_confirmation_email_subject')
    end
  end

end
