class Location < ApplicationRecord

  # Associations
  has_one :address, dependent: :destroy
  has_many :deals_locations
  has_many :deals, through: :deals_locations
  # Validations
  validates :name, presence: true
  validates :address, presence: true

  accepts_nested_attributes_for :address

end
