class Location < ApplicationRecord

  # Associations
  has_one :address, dependent: :destroy
  has_many :deals_locations
  has_many :deals, through: :deals_locations
  accepts_nested_attributes_for :address
  # Validations
  validates :name, presence: true
  validates :address, presence: true

end
