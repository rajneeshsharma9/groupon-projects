class User < ApplicationRecord

  REGEXP_EMAIL = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  
  enum role: [:customer, :admin]
  has_secure_password

  validates :name, presence: true
  validates :email, uniqueness: true, format: {
    with:    REGEXP_EMAIL,
    message: 'must be a valid email address.'
  }

  after_initialize do
    if self.new_record?
      self.role ||= :customer
    end
  end

end