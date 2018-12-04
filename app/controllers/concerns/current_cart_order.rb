module CurrentCartOrder

  private def set_cart_order
    if logged_in?
      @order = current_user.current_order
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
