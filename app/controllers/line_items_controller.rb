class LineItemsController < ApplicationController

  before_action :set_cart_order, only: [:create, :decrement]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy, :decrement]
  skip_before_action :authorize, only: [:create, :decrement]

  def index
    @line_items = LineItem.all
  end

  def show; end

  def new
    @line_item = LineItem.new
  end

  def edit; end

  def create
    deal = Deal.find(params[:deal_id])
    @line_item = @order.add_deal(deal)
    if @line_item.save
      redirect_to cart_path, success: t('.line_item_added')
    else
      redirect_to home_page_path, danger: @order.errors.full_messages.join(', ')
    end
  end

  def update
    if @line_item.update(line_item_params)
      redirect_to line_item_path(@line_item), info: t('.line_item_updated')
    else
      flash.now[:danger] = t('.error_has_occured')
      render :edit
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
      if @line_item.quantity == 0
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

  private def line_item_params
    params.require(:line_item).permit(:deal_id)
  end

  private def set_cart_order
    if logged_in?
      @order = current_user.orders.where.not(workflow_state: %w[completed cancelled]).last
      unless @order
        @order = current_user.orders.create
      end
    else
      @order = Order.find_by(id: session[:order_id])
      unless @order
        @order = Order.create
        session[:order_id] = @order.id
      end
    end
  end

end
