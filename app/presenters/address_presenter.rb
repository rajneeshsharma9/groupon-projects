class AddressPresenter < ApplicationPresenter

  presents :address

  # Methods delegated to Presented Class Address object's address
  @delegation_methods = [:slice]

  delegate *@delegation_methods, to: :address

  def readable_format
    slice(:street_address, :city, :state, :country, :pincode).values.join(', ')
  end

end
