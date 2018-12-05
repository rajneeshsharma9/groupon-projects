class OrdersController < ApplicationController

  include CurrentOrderFinder
  include LineItemsHandler

  before_action :set_current_order
  before_action :set_deal, only: %i[update]
  before_action :set_line_item, only: %i[update]
  skip_before_action :authorize, only: %i[cart update]

  def cart
    @line_items = @order.line_items.includes(:deal)
  end

  def update
    if params[:task] == 'decrement' && @line_item.quantity > 1
      decrement_line_item_quantity
    elsif params[:task] == 'decrement' && @line_item.quantity == 1 || params[:task] == 'destroy'
      destroy_line_item
    else
      create_line_item
    end
  end

  def checkout; end

end
