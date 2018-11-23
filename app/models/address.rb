class Address < ApplicationRecord

  include BasicPresenter::Concern
  # Associations
  belongs_to :location
  # Validations
  validates :street_address, :city, :state, :country, :pincode, presence: true

end
