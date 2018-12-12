class Refund < ApplicationRecord
  # Constants
  MINIMUM_ALLOWED_AMOUNT = 0.01
  MAXIMUM_ALLOWED_AMOUNT = 99999.99
  # Associations
  belongs_to :payment
  belongs_to :line_item
  # Validations
  validates :refund_id, :amount_refunded, :refund_data, presence: true
  validates :amount_refunded, numericality: { greater_than_or_equal_to: MINIMUM_ALLOWED_AMOUNT, less_than_or_equal_to: MAXIMUM_ALLOWED_AMOUNT }, allow_nil: true

end
