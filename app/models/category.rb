class Category < ApplicationRecord

  # Associations
  has_many :deals
  # Validations
  validates :name, presence: true

end
