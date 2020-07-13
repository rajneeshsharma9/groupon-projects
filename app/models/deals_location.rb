class DealsLocation < ApplicationRecord

  MINIMUM_ALLOWED_COUNT = 1
  # Associations
  belongs_to :deal
  belongs_to :location
  # Validations
  validates :deal_id, uniqueness: { scope: [:location_id] }
  validates :total_deals, presence: true, if: :finite_total_deals?
  validates :total_deals, numericality: { greater_than_or_equal_to: MINIMUM_ALLOWED_COUNT }, allow_nil: true

  def deals_left
    if finite_total_deals
      total_deals - deals_sold
    end
  end

  def finite_total_deals?
  end

end
