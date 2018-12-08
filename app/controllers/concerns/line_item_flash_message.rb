module LineItemFlashMessage

  private def success_message(task)
    if task == 'increment'
      I18n.t :deal_added
    else
      I18n.t :deal_removed
    end
  end

  private def error_message
    @order.errors.full_messages.join(', ')
  end

end
