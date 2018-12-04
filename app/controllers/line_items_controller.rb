class LineItemsController < ApplicationController

  include CurrentCartOrder

  before_action :set_cart_order, only: %i[create decrement]
  before_action :set_deal, only: %i[create]
  before_action :set_line_item, only: %i[destroy decrement]
  skip_before_action :authorize, only: %i[create decrement destroy]

  def create
    @line_item = @order.add_deal(@deal)
    if @line_item.save
      redirect_to cart_path, success: t('.line_item_added')
    else
      redirect_to home_page_path, danger: @order.errors.full_messages.join(', ')
    end
  end

  def destroy
    if @line_item.destroy
      redirect_to home_page_path, success: t('.empty_cart')
    else
      redirect_to cart_path, danger: t('.error_has_occured')
    end
  end

  def decrement
    @line_item.quantity -= 1
    if @line_item.save
      if @line_item.quantity.zero?
        destroy
      else
        redirect_to cart_path, success: t('.removed_from_cart')
      end
    else
      redirect_to home_page_path, danger: t('.error_has_occured')
    end
  end

  private def set_line_item
    @line_item = LineItem.find(params[:id])
    if @line_item.nil?
      redirect_to cart_path, danger: t('.line_item_not_present')
    end
  end

  private def set_deal
    @deal = Deal.find(params[:deal_id])
    if @deal.nil?
      redirect_to home_page_path, danger: t('.deal_not_present')
    end
  end

  private def line_item_params
    params.require(:line_item).permit(:deal_id)
  end

end
