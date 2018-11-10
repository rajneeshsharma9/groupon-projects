module Tokenizer
  
  include ActiveSupport::Concern

  def new_token
    SecureRandom.urlsafe_base64.to_s
  end

  def create_digest(string)
    BCrypt::Password.create(string)
  end

end
