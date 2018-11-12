module Authenticator
  
  include ActiveSupport::Concern
  include Tokenizer
  
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

  def set_reset_digest
    self.reset_token = new_token
    update(reset_digest: create_digest(reset_token), reset_sent_at: Time.current)
  end

  def send_password_reset_email
    SendPasswordResetEmailJob.perform_later(id, reset_token)
  end

  def password_reset_expired?
    reset_sent_at < RESET_TOKEN_EXPIRY_TIME.ago
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
        self.verification_token = new_token
        if User.find_by(verification_token: verification_token).nil?
          break
        end
      end
    end

end
