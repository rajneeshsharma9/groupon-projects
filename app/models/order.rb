class Order < ApplicationRecord

  define_model_callbacks :update_cart, only: %i[before after]
  # Workflow
  include OrderWorkflow
  # Line item methods
  include LineItemsHandler
  # Current actor from controllers
  attr_accessor :current_user
  # Constants
  MINIMUM_ALLOWED_AMOUNT = 0.00
  MAXIMUM_ALLOWED_AMOUNT = 99999.99
  # Associations
  has_one :billing_address, as: :addressable, dependent: :destroy, validate: true, class_name: 'Address'
  belongs_to :user, optional: true
  has_many :line_items, dependent: :destroy
  has_many :deals, through: :line_items
  has_one :payment, dependent: :destroy
  # Callbacks
  before_update_cart :reset_state
  after_update_cart :update_price
  # Validations
  validates :workflow_state, presence: true
  validates :receiver_email, presence: true, if: :receiver_email_changed?
  validates :amount, numericality: { greater_than_or_equal_to: MINIMUM_ALLOWED_AMOUNT, less_than_or_equal_to: MAXIMUM_ALLOWED_AMOUNT }, allow_nil: true
  validates :line_items, length: { maximum: 1, message: ': Only one deal allowed in cart at a time. Please remove it from cart first.' }
  validates :receiver_email, format: {
    with:    EMAIL_REGEXP,
    message: :invalid_email
  }, allow_blank: true

  def update_cart(params, deal, line_item)
    @deal = deal
    @line_item = line_item
    Order.transaction do
      run_callbacks :update_cart do
        if params[:task] == 'decrement' && @line_item.quantity > 1
          decrement_line_item_quantity!
        elsif params[:task] == 'decrement' && @line_item.quantity == 1 || params[:task] == 'destroy'
          destroy_line_item!
        elsif params[:task] == 'increment'
          increment_quantity_or_create_line_item!
        end
      end
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotDestroyed
    false
  end

  def total_price
    line_items.reload.to_a.sum(&:total_price)
  end

  private def update_price
    update(amount: total_price)
  end

  private def reset_state
    update_columns(workflow_state: 'cart')
  end

end
