class PaymentService

  def initialize(order)
    @order = order
  end

  def authorize(params)
    @charge = Stripe::Charge.create(
      amount: @order.amount.to_i * 100,
      description: I18n.t('payment_description'),
      currency: 'usd',
      source: params[:stripeToken],
      capture: false,
      statement_descriptor: I18n.t('statement_description')
    )
    { success: true }
  rescue Stripe::CardError, Stripe::RateLimitError, Stripe::InvalidRequestError, Stripe::AuthenticationError, Stripe::APIConnectionError, Stripe::StripeError => error
    return { errors: error.message, success: false }
  end

  def build_payment_params_hash
    { amount_captured: @order.amount, state: 'auth', charge_id: @charge.id, last_four_card_digits: @charge.source.last4, charge_data: @charge.to_json, transaction_id: @charge.balance_transaction, source_id: @charge.source.id }
  end

  def capture
    @charge.capture
    { success: true }
  rescue Stripe::CardError, Stripe::RateLimitError, Stripe::InvalidRequestError, Stripe::AuthenticationError, Stripe::APIConnectionError, Stripe::StripeError => error
    return { errors: error.message, success: false }
  end

end
