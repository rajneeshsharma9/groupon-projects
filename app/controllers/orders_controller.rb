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
  end

end
