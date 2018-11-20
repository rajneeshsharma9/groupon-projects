class DealsLocation < ApplicationRecord

  # Associations
  belongs_to :deal
  belongs_to :location
  # Validations
  validates :deal_id, uniqueness: { scope: [:location_id] }

end
