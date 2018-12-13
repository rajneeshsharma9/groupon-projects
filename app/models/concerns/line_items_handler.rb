module LineItemsHandler

  private def increment_quantity_or_create_line_item!
    current_item = line_items.find_by(deal_id: @deal.id) || line_items.build(deal_id: @deal.id)
    current_item.quantity += 1
    current_item.price_per_quantity = @deal.price
    current_item.save!
  end

  private def destroy_line_item!
    @line_item.destroy!
  end

  private def decrement_line_item_quantity!
    @line_item.price_per_quantity = @deal.price
    @line_item.decrement(:quantity).save!
  end

  private def check_if_deal_unpublished
    if @deal.published_at.nil?
      errors.add(:base, 'Unpublished deals cannot be bought')
      @line_item.destroy
      throw(:abort)
    end
  end

  private def check_if_deal_expired
    if @deal.expired?
      errors.add(:base, 'Expired deals cannot be bought')
      @line_item.destroy
      throw(:abort)
    end
  end

end
