class PaymentsController < ApplicationController

  before_action :set_current_order
  before_action :check_order_state, only: %i[create]
  before_action :set_current_user, only: %i[create]

  def create
    @order_payment = PaymentService.new(@order)
    authorize = @order_payment.authorize(params)
    authorize_successful = authorize[:success]
    @payment = @order.build_payment(@order_payment.build_payment_params_hash) if authorize_successful
    if authorize_successful && capture_order_amount
      redirect_to home_page_path, success: t('.successful_order')
    else
      redirect_to edit_order_path, danger: t('.payment_failed')
    end
  end

  private def capture_order_amount
    Payment.transaction do
      @payment.state = 'capture'
      if @payment.save && @order.pay! && @order_payment.capture[:success]
        true
      else
        raise ActiveRecord::Rollback
      end
    end
  rescue ActiveRecord::Rollback
    false
  end

  private def check_order_state
    unless @order.address?
      redirect_to edit_order_path, danger: t('.payment_not_allowed')
    end
  end

  private def set_current_user
    @order.current_user = current_user
  end

end
