class OrdersController < ApplicationController

  include LineItemFlashMessage

  before_action :set_current_order
  before_action :set_current_user, only: %i[edit update]
  skip_before_action :authorize, only: %i[cart update_cart]

  def cart
    @line_items = @order.line_items.includes(:deal)
  end

  def update_cart
    if @order.update_cart(permitted_order_params)
      redirect_to cart_path, success: success_message(permitted_order_params[:task])
    else
      redirect_to cart_path, danger: error_message
    end
  end

  def index
    @orders = current_user.orders.with_completed_state
  end

  def edit; end

  def update
    if @order.cart?
      update_email
    elsif @order.email?
      update_address
    elsif @order.address?
      confirm
    end
  end

  private def update_email
    if @order.update_receiver_email!(params[:order][:receiver_email])
      redirect_to edit_order_path, success: t('.enter_address')
    else
      redirect_to edit_order_path, danger: @order.halted_because
    end
  end

  private def update_address
    if @order.update_address!(permitted_address_params)
      redirect_to edit_order_path, success: t('.confirm_order')
    else
      redirect_to edit_order_path, danger: @order.halted_because
    end
  end

  private def confirm
    if @order.confirm!
      redirect_to edit_order_path, success: t('.payment_request')
    else
      redirect_to edit_order_path, danger: @order.halted_because
    end
  end

  private def set_current_user
    @order.current_user = current_user
  end

  private def permitted_order_params
    params.permit(:deal_id, :task)
  end

  private def permitted_address_params
    params[:order][:address].permit(:id, :street_address, :state, :city, :country, :pincode).to_h
  end

end
