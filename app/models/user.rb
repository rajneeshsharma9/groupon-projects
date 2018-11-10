class User < ApplicationRecord
  
  ROLES = ({ customer: 0, admin: 1 }).freeze
  PASSWORD_VALIDATION_RANGE = (6..20).freeze

  attr_accessor :reset_token, :remember_token

  has_secure_password

  enum role: ROLES

  # Validations
  validates :name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }, format: {
    with:    EMAIL_REGEXP,
    message: :invalid_email
  }, allow_blank: true
  validates :verification_token, uniqueness: { case_sensitive: false }, allow_nil: true
  validates :password, length: { in: PASSWORD_VALIDATION_RANGE }, allow_blank: true
  #Callbacks
  before_create :set_verification_token
  after_create_commit :send_verification_email

  def verify_email
    update_columns(verified_at: Time.current, verification_token: nil)
  end

  def activated?
    verified_at.present?
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def remember
    self.remember_token = SecureRandom.urlsafe_base64.to_s
    update_attribute(:remember_digest, BCrypt::Password.create(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def create_reset_digest
    self.reset_token = SecureRandom.urlsafe_base64.to_s
    update_attribute(:reset_digest, BCrypt::Password.create(reset_token))
    update_attribute(:reset_sent_at, Time.current)
  end

  def send_password_reset_email
    SendPasswordResetEmailJob.perform_later(id, reset_token)
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private
    def send_verification_email
      SendVerificationEmailJob.perform_later(id) if customer?
    end

    def set_verification_token
      if verification_token.present?
        return false
      end  
      loop do
        self.verification_token = SecureRandom.urlsafe_base64.to_s
        if User.find_by(verification_token: verification_token).nil?
          break
        end
      end
    end

end
