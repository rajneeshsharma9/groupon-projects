class PaymentsController < ApplicationController

  before_action :set_current_order
  before_action :set_current_user, only: %i[create]

  def create
    @order_payment = PaymentService.new(@order)
    @order_payment.authorize(params)
    @payment = @order.build_payment(@order_payment.build_payment_params_hash)
    if capture_order_amount
      redirect_to home_page_path, success: t('.successful_order')
    else
      redirect_to edit_order_path, danger: @payment.errors.full_messages
    end
  rescue Stripe::CardError => error
    redirect_to edit_order_path, danger: error.message
  rescue Stripe::RateLimitError, Stripe::InvalidRequestError, Stripe::AuthenticationError, Stripe::APIConnectionError, Stripe::StripeError
    redirect_to edit_order_path, danger: t('.payment_error')
  end

  private def capture_order_amount
    Payment.transaction do
      @payment.state = 'capture'
      if @payment.save && @order.pay!
        @order_payment.capture
      else
        raise ActiveRecord::Rollback
      end
    end
  end

  private def set_current_user
    @order.current_user = current_user
  end

end
