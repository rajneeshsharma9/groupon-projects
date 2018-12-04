class Order < ApplicationRecord

  attr_accessor :current_user
  # Constants
  MINIMUM_ALLOWED_AMOUNT = 0.00
  MAXIMUM_ALLOWED_AMOUNT = 99999.99
  # Workflow
  include Workflow
  workflow do
    state :cart do
      event :update_receiver_email, transitions_to: :email, if: ->(order) { order.owner? }
      event :cancel, transitions_to: :cancelled, if: ->(order) { order.admin? }
    end
    state :email do
      event :update_address, transitions_to: :address, if: ->(order) { order.owner? }
      event :cancel, transitions_to: :cancelled, if: ->(order) { order.admin? }
    end
    state :address do
      event :confirm, transitions_to: :completed, if: ->(order) { order.owner? }
      event :cancel, transitions_to: :cancelled, if: ->(order) { order.admin? }
    end
    state :completed do
      event :deliver, transitions_to: :delivered, if: ->(order) { order.admin? }
      event :cancel, transitions_to: :cancelled, if: ->(order) { order.admin? }
    end
    state :delivered
    state :cancelled
  end
  # Associations
  has_one :address, as: :addressable, dependent: :destroy, validate: true
  belongs_to :user, optional: true
  has_many :line_items, dependent: :destroy
  has_many :deals, through: :line_items
  # Callbacks
  # Validations
  validates :line_items, length: { maximum: 1, message: ': Only one deal allowed in cart at a time. Please remove it from cart first.' }
  validates :workflow_state, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: MINIMUM_ALLOWED_AMOUNT }, allow_nil: true
  validates :amount, numericality: { less_than_or_equal_to: MAXIMUM_ALLOWED_AMOUNT }, allow_nil: true
  validates :receiver_email, format: {
    with:    EMAIL_REGEXP,
    message: :invalid_email
  }, allow_blank: true

  def update_receiver_email(email)
    if update(receiver_email: email)
    else
      halt! errors.full_messages
    end
  end

  def update_address(address_params)
    build_address(address_params)
    unless save
      halt! errors.full_messages
    end
  end

  def cancel
    if update(cancelled_at: Time.current, cancelled_by: current_user)
    else
      halt! errors.full_messages
    end
  end

  def confirm
    if update(confirmed_at: Time.current)
    else
      halt! errors.full_messages
    end
  end

  def deliver
    if update(delivered_at: Time.current)
    else
      halt! errors.full_messages
    end
  end

  def owner?
    if user.present? && current_user == user
      true
    else
      halt! 'You dont own this order'
    end
  end

  def admin?
    if current_user.admin? && current_user != user
      true
    else
      halt! 'You dont have the privileges to do this'
    end
  end

  def add_deal(deal)
    current_item = line_items.find_by(deal_id: deal.id)
    unless current_item
      current_item = line_items.build(deal_id: deal.id)
    end
    current_item.quantity += 1
    current_item.price = deal.price
    current_item
  end

  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end

end
