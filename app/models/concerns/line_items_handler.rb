module LineItemsHandler

  private def increment_quantity_or_create_line_item
    current_item = line_items.find_by(deal_id: @deal.id) || line_items.build(deal_id: @deal.id)
    current_item.quantity += 1
    current_item.price_per_quantity = @deal.price
    current_item.save
  end

  private def destroy_line_item
    @line_item.destroy
  end

  private def decrement_line_item_quantity
    @line_item.decrement(:quantity).save
  end

end
