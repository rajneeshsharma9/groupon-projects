class OrdersController < ApplicationController

  include LineItemFlashMessage

  before_action :set_current_order
  before_action :set_current_user, only: %i[edit update]
  before_action :set_deal, only: %i[update_cart]
  before_action :set_line_item, only: %i[update_cart]
  skip_before_action :authorize, only: %i[cart]

  def cart
    @line_items = @order.line_items.includes(:deal)
  end

  def update_cart
    if @order.update_cart(permitted_order_params, @deal, @line_item)
      redirect_to cart_path, success: success_message(permitted_order_params[:task])
    else
      redirect_to home_page_path, danger: error_message
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
      flash.now[:danger] = @order.halted_because
      render :edit
    end
  end

  private def set_current_user
    @order.current_user = current_user
  end

  private def permitted_order_params
    params.permit(:deal_id, :task)
  end

  private def permitted_address_params
    params[:order][:billing_address].permit(:id, :street_address, :state, :city, :country, :pincode).to_h
  end

  private def set_line_item
    @line_item = @order.line_items.find_by(deal_id: params[:deal_id])
  end

  private def set_deal
    @deal = Deal.find_by(id: params[:deal_id])
    if @deal.nil?
      redirect_to home_page_path, danger: t('.deal_not_present')
    end
  end

end
