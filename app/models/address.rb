class Address < ApplicationRecord

  # Associations
  belongs_to :location
  # Validations
  validates :street_address, :city, :state, :country, :pincode, presence: true

  def readable_format
    slice(:street_address, :city, :state ,:country, :pincode).values.join(', ')
  end

end
