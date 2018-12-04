class OrdersController < ApplicationController

  include CurrentCartOrder

  before_action :set_cart_order, only: %i[cart]
  skip_before_action :authorize, only: %i[cart]

  def cart
    if @order.line_items.present?
      @line_items = @order.line_items.includes(:deal)
    end
  end

  def checkout; end

end
