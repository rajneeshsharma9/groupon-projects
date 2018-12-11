module CurrentOrderFinder

  private def set_current_order
    set_user_order
  end

  private def set_user_order
    @order = current_user.current_order || current_user.orders.create!
  end

  # private def set_session_order
  #   @order = Order.find_by(id: session[:order_id])
  #   unless @order
  #     @order = Order.create!
  #     session[:order_id] = @order.id
  #   end
  # end

end
