class LineItem < ApplicationRecord
  # Associations
  belongs_to :order, validate: true
  belongs_to :deal
  # Validations
  validates :deal_id, uniqueness: { scope: [:order_id] }

  def total_price
    price * quantity
  end

end
