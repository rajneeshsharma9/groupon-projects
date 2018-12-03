class Order < ApplicationRecord
  # Workflow
  include OrderWorkflow
  attr_accessor :current_user
  # Constants
  MINIMUM_ALLOWED_AMOUNT = 0
  MAXIMUM_ALLOWED_AMOUNT = 99999.99
  # Associations
  has_one :billing_address, as: :addressable, dependent: :destroy, validate: true, class_name: 'Address'
  belongs_to :user, optional: true
  has_many :line_items, dependent: :destroy
  has_many :deals, through: :line_items
  # Callbacks
  # Validations
  validates :workflow_state, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: MINIMUM_ALLOWED_AMOUNT, less_than_or_equal_to: MAXIMUM_ALLOWED_AMOUNT }, allow_nil: true
  validates :receiver_email, format: {
    with:    EMAIL_REGEXP,
    message: :invalid_email
  }, allow_blank: true

  def add_deal(deal)
    current_item = line_items.find_by(deal_id: deal.id)
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(deal_id: deal.id)
    end
    current_item.price = deal.price
    current_item
  end

  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end

end
