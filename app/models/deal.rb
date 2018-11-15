class Deal < ApplicationRecord

  # Validations
  validates :title, presence: true
  validates :title, uniqueness: { case_sensitive: false }, allow_nil: true
  validates :minimum_purchases_required, numericality: { greater_than_or_equal_to: 0 }
  validates :maximum_purchases_allowed, numericality: { greater_than: :minimum_purchases_required }
  validates :start_at, :expire_at, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }, allow_nil: true
  validates :price, numericality: { less_than_or_equal_to: 9999.99 }, allow_nil: true
  validates :maximum_purchases_per_customer, numericality: { greater_than_or_equal_to: 0 }
  validates :maximum_purchases_per_customer, numericality: { less_than_or_equal_to: :maximum_purchases_allowed }
  validates_with DateValidator

end
