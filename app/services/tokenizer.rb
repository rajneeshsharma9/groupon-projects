class Tokenizer

  def self.new_token
    SecureRandom.urlsafe_base64.to_s
  end

  def self.create_digest(string)
    BCrypt::Password.create(string)
  end

  def self.digest_of?(digest, token)
    BCrypt::Password.new(digest).is_password?(token)
  end

end
