class Category < ApplicationRecord

  # Associations
  has_many :deals
  # Validations
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }, allow_blank: true

end
