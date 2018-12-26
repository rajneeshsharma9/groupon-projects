class SendOrderCancellationEmailJob < ActiveJob::Base

  def perform(order_id)
    OrderMailer.send_order_cancellation_email(order_id).deliver_now
  end

end
