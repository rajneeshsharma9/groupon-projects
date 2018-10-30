class User < ApplicationRecord
  
  ROLES = { customer: 0, admin: 1 }
  enum role: ROLES
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true
  validates :email, :uniqueness => { :case_sensitive => false }, format: {
    with:    EMAIL_REGEXP,
    message: I18n.t('.invalid_email')
  }, allow_blank: true

end
