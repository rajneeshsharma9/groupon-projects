class LineItem < ApplicationRecord
  # Constants
  MINIMUM_ALLOWED_QUANTITY = 0
  # Associations
  belongs_to :order, validate: true
  belongs_to :deal
  # Validations
  validates :deal_id, uniqueness: { scope: [:order_id] }
  validates :quantity, numericality: { greater_than_or_equal_to: MINIMUM_ALLOWED_QUANTITY }, allow_nil: true

  def total_price
    price * quantity
  end

end
