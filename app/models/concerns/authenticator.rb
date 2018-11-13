module Authenticator

  extend ActiveSupport::Concern

  def verify_email
    update(verified_at: Time.current, verification_token: nil)
  end

  def activated?
    verified_at.present?
  end

  def authenticated_token?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    Tokenizer.digest_of?(digest, token)
  end

  def set_reset_digest
    self.reset_token = Tokenizer.new_token
    update(reset_digest: Tokenizer.create_digest(reset_token), reset_sent_at: Time.current)
  end

  def send_password_reset_email
    SendPasswordResetEmailJob.perform_later(id, reset_token)
  end

  def password_reset_expired?
    reset_sent_at < RESET_TOKEN_EXPIRY_TIME.ago
  end

  private def send_verification_email
    SendVerificationEmailJob.perform_later(id) if customer?
  end

  private def set_verification_token
    return false if verification_token.present?
    loop do
      self.verification_token = Tokenizer.new_token
      if User.find_by(verification_token: verification_token).nil?
        break
      end
    end
  end

end
