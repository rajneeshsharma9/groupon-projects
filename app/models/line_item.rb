class LineItem < ApplicationRecord
  # Constants
  MINIMUM_ALLOWED_QUANTITY = 1
  # Associations
  belongs_to :order, validate: true
  belongs_to :deal
  # Callbacks
  after_rollback :add_errors_to_order
  # Validations
  validates :price_per_quantity, presence: true
  validates :price_per_quantity, numericality: { greater_than_or_equal_to: MINIMUM_ALLOWED_PRICE, less_than_or_equal_to: MAXIMUM_ALLOWED_PRICE }, allow_nil: true
  validates :deal_id, uniqueness: { scope: [:order_id] }
  validates :quantity, numericality: { greater_than_or_equal_to: MINIMUM_ALLOWED_QUANTITY }, allow_nil: true
  validate :check_if_deal_expired
  validate :check_order_state
  validate :check_deal_quantity

  def total_price
    price_per_quantity * quantity
  end

  private def add_errors_to_order
    order.errors.add(:base, errors.full_messages)
  end

  private def check_if_deal_expired
    if deal.expired?
      errors.add(:base, 'Expired deals cannot be bought')
    end
  end

  private def check_deal_quantity
    if quantity + order.user&.purchased_deal_quantity(deal.id) > deal.maximum_purchases_per_customer || quantity > deal.quantity_left
      errors.add(:base, 'No more purchases of this deal per customer allowed')
    end
  end

  private def check_order_state
    if order.completed? || order.cancelled?
      errors.add(:base, 'LineItem cannot be added to this order')
    end
  end

end
