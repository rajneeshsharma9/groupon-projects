module LineItemsHandler

  private def create_line_item
    current_item = line_items.find_by(deal_id: @deal.id)
    current_item ||= line_items.build(deal_id: @deal.id)
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

  private def set_line_item
    # no need to check if line_item found or not as add_deal handles it
    @line_item = line_items.find_by(deal_id: @params[:deal_id])
  end

  private def set_deal
    @deal = Deal.find_by(id: @params[:deal_id])
    if @deal.nil?
      redirect_to home_page_path, danger: t('.deal_not_present')
    end
  end

end
