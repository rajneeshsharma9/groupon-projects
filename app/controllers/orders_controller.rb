class OrdersController < ApplicationController

  before_action :set_cart_order, only: [:cart]
  skip_before_action :authorize, only: [:cart]

  def cart
    if @order.line_items.present?
      @line_item = @order.line_items.first
      @deal = @line_item.deal
    end
  end

  def checkout
  end

  private def set_cart_order
    @order = Order.find_by(id: session[:order_id])
    unless @order
      @order = Order.create
      session[:order_id] = @order.id
    end
  end

end
