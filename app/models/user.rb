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
  # validates :verification_token, uniqueness: { case_sensitive: false }

  #Callbacks
  before_create :set_verification_token
  after_create_commit :send_verification_email

  def verify_email
    self.verified_at = Time.current
    self.verification_token = nil
    save(validate: false)
  end

  private
    def send_verification_email
      #mail will not be sent for admin creation
      UserMailer.send_verification_email(id).deliver_later
    end

    def set_verification_token
      if self.verification_token.blank?
        self.verification_token = SecureRandom.urlsafe_base64.to_s
      end
    end

end
