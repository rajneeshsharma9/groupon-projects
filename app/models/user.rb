class User < ApplicationRecord
  
  ROLES = ({ customer: 0, admin: 1 }).freeze

  has_secure_password

  enum role: ROLES

  # Validations
  validates :name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }, format: {
    with:    EMAIL_REGEXP,
    message: :invalid_email
  }, allow_blank: true

  #Callbacks
  after_create_commit :send_verification_email

  private
    def send_verification_email
      #mail will not be sent for admin creation
    end

end
