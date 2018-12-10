module OrderWorkflow

  DEAL_AVAILABILITY_STATES = %i[payment completed].freeze
  extend ActiveSupport::Concern

  included do
    include Workflow
    workflow do
      state :cart do
        event :update_receiver_email, transitions_to: :email, if: ->(order) { order.check_if_owner }
        event :cancel, transitions_to: :cancelled, if: ->(order) { order.check_if_admin }
      end
      state :email do
        event :update_address, transitions_to: :address, if: ->(order) { order.check_if_owner }
        event :cancel, transitions_to: :cancelled, if: ->(order) { order.check_if_admin }
      end
      state :address do
        event :confirm, transitions_to: :payment, if: ->(order) { order.check_if_owner }
        event :cancel, transitions_to: :cancelled, if: ->(order) { order.check_if_admin }
      end
      state :payment do
        event :pay, transitions_to: :completed, if: ->(order) { order.check_if_owner }
        event :cancel, transitions_to: :cancelled, if: ->(order) { order.check_if_admin }
      end
      state :completed do
        event :deliver, transitions_to: :delivered, if: ->(order) { order.check_if_admin }
        event :cancel, transitions_to: :cancelled, if: ->(order) { order.check_if_admin }
      end
      state :delivered
      state :cancelled

      before_transition do |_from_state, to_state, _event|
        check_deals_availability if DEAL_AVAILABILITY_STATES.include?(to_state)
        check_deals_expiry
      end
    end
  end

  def check_deals_availability
    line_items.each do |line_item|
      if line_item.quantity > line_item.deal.quantity_left
        halt! "Sorry, #{line_item.deal.title} is out of stock now."
      end
    end
  end

  def check_deals_expiry
    deals.each do |deal|
      if deal.expire_at < Time.current
        halt! "Sorry, #{deal.title} is expired now."
      end
    end
  end

  def update_receiver_email(email)
    unless update(receiver_email: email)
      halt errors.full_messages
    end
  end

  def update_address(address_params)
    build_billing_address(address_params)
    unless save
      halt errors.full_messages
    end
  end

  def cancel
    unless update(cancelled_at: Time.current, cancelled_by: current_user)
      halt errors.full_messages
    end
  end

  def confirm
    unless update(confirmed_at: Time.current)
      halt errors.full_messages
    end
  end

  def deliver
    unless update(delivered_at: Time.current)
      halt errors.full_messages
    end
  end

  def check_if_owner
    if user.present? && current_user == user
      true
    else
      halt 'You dont own this order'
      false
    end
  end

  def check_if_admin
    if current_user.check_if_admin && current_user != user
      true
    else
      halt 'You dont have the privileges to do this'
      false
    end
  end

end
