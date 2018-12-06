class OrdersController < ApplicationController

  include CurrentOrderFinder
  include LineItemFlashMessage

  before_action :set_current_order
  skip_before_action :authorize, only: %i[cart update]

  def cart
    @line_items = @order.line_items.includes(:deal)
  end

  def update
    if @order.update_cart(permitted_order_params)
      redirect_to cart_path, success: success_message(permitted_order_params[:task])
    else
      redirect_to cart_path, danger: error_message
    end
  end

  def checkout; end

  def permitted_order_params
    params.permit(:deal_id, :task)

  def update_email
    email = params[:order][:receiver_email]
    @order.current_user = current_user
    if @order.update_receiver_email!(email)
      redirect_to order_address_path, success: 'Enter billing address'
    else
      redirect_to checkout_path, danger: @order.halted_because
    end
  end

  def address; end

  def confirmation; end

  def confirm
    @order.current_user = current_user
    if @order.confirm!
      redirect_to home_page_path, success: 'Order placed successfully'
    else
      redirect_to confirmation_path, danger: @order.halted_because
    end
  end

  def update_address
    address = permitted_address_params
    @order.current_user = current_user
    if @order.update_address!(address)
      redirect_to confirmation_path, success: 'Enter billing address'
    else
      redirect_to order_address_path, danger: @order.halted_because
    end
  end

  private def permitted_address_params
    params[:order][:address].permit!.to_h
  end

end
