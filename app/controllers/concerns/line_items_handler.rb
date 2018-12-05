module LineItemsHandler

  private def create_line_item
    if @order.add_deal(@deal)
      redirect_to cart_path, success: t('.line_item_added')
    else
      redirect_to cart_path, danger: @order.errors.full_messages.join(', ')
    end
  end

  private def destroy_line_item
    if @line_item.destroy
      redirect_to home_page_path, success: t('.empty_cart')
    else
      redirect_to cart_path, danger: t('.error_has_occured')
    end
  end

  private def decrement_line_item_quantity
    if @line_item.decrement
      redirect_to cart_path, success: t('.removed_from_cart')
    else
      redirect_to home_page_path, danger: t('.error_has_occured')
    end
  end

  private def set_line_item
    # no need to check if line_item found or not as add_deal handles it
    @line_item = @order.line_items.find_by(deal_id: params[:deal_id])
  end

  private def set_deal
    @deal = Deal.find(params[:deal_id])
    if @deal.nil?
      redirect_to home_page_path, danger: t('.deal_not_present')
    end
  end

end
