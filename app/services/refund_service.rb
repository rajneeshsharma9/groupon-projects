class RefundService

  def initialize(order)
    @order = order
  end

  def refund
    @refund = Stripe::Refund.create ({
      charge: @order.payment.charge_id
    })
    { success: true }
  rescue Stripe::CardError, Stripe::RateLimitError, Stripe::InvalidRequestError, Stripe::AuthenticationError, Stripe::APIConnectionError, Stripe::StripeError => error
    { errors: error.message, success: false }
  end

  def build_refund_params_hash
    { amount_refunded: @order.amount, refund_data: @refund.to_json, refund_id: @refund.id }
  end

end
