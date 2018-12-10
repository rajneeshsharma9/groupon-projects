class PaymentsController < ApplicationController

  before_action :set_current_order
  before_action :set_current_user, only: %i[create]

  def create
    @charge = Stripe::Charge.create(
      amount: @order.amount.to_i * 100,
      description: t('.payment_description'),
      currency: 'usd',
      source: params[:stripeToken],
      capture: false,
      statement_descriptor: t('.statement_description')
    )
    @payment = @order.build_payment(payment_params)
    if capture_order_amount
      redirect_to home_page_path, success: t('.successful_order')
    else
      redirect_to edit_order_path, danger: @payment.errors.full_messages
    end
  rescue Stripe::CardError => error
    redirect_to edit_order_path, danger: error.message
  end

  private def payment_params
    { amount_captured: @order.amount, state: 'auth', charge_id: @charge.id, last_four_card_digits: @charge.source.last4, charge_data: @charge.to_json, transaction_id: @charge.balance_transaction, source_id: @charge.source.id }
  end

  private def capture_order_amount
    Payment.transaction do
      @charge.capture
      @payment.state = 'capture'
      @order.pay!
      if @payment.save
        true
      else
        raise ActiveRecord::Rollback
      end
    end
  end

  private def set_current_user
    @order.current_user = current_user
  end

end
