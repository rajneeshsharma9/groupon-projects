class Address < ApplicationRecord

  include BasicPresenter::Concern
  @delegation_methods = [:readable_format]
  delegate *@delegation_methods, to: :presenter
  # Associations
  belongs_to :location
  # Validations
  validates :street_address, :city, :state, :country, :pincode, presence: true

end
