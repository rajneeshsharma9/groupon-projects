class Order < ApplicationRecord
  # Workflow
  include OrderWorkflow
  attr_accessor :current_user
  # Constants
  MINIMUM_ALLOWED_AMOUNT = 0
  MAXIMUM_ALLOWED_AMOUNT = 99999.99
  # Associations
  has_one :address, as: :addressable, dependent: :destroy, validate: true
  belongs_to :user, optional: true
  # Callbacks
  # Validations
  validates :workflow_state, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: MINIMUM_ALLOWED_AMOUNT, less_than_or_equal_to: 9999.99 }, allow_nil: true
  validates :receiver_email, format: {
    with:    EMAIL_REGEXP,
    message: :invalid_email
  }, allow_blank: true

end
