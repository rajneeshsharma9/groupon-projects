class Payment < ApplicationRecord

  STATES = ({ auth: 0, capture: 1 }).freeze
  MINIMUM_ALLOWED_AMOUNT = 0.01
  MAXIMUM_ALLOWED_AMOUNT = 99999.99

  enum state: STATES
  # Associations
  belongs_to :order
  has_many :refunds
  # Validations
  validates :amount_captured, :state, :charge_id, :last_four_card_digits, :charge_data, :source_id, presence: true
  validates :amount_captured, numericality: { greater_than_or_equal_to: MINIMUM_ALLOWED_AMOUNT, less_than_or_equal_to: MAXIMUM_ALLOWED_AMOUNT }, allow_nil: true

end
