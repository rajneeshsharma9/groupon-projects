module OrderWorkflow

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
        event :confirm, transitions_to: :completed, if: ->(order) { order.check_if_owner }
        event :cancel, transitions_to: :cancelled, if: ->(order) { order.check_if_admin }
      end
      state :completed do
        event :deliver, transitions_to: :delivered, if: ->(order) { order.check_if_admin }
        event :cancel, transitions_to: :cancelled, if: ->(order) { order.check_if_admin }
      end
      state :delivered
      state :cancelled
    end
  end

  def update_receiver_email(email)
    unless update(receiver_email: email)
      halt errors.full_messages
    end
  end

  def update_address(address_params)
    build_address(address_params)
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
