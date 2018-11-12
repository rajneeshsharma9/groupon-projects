module LoginAuthenticator
  
  include ActiveSupport::Concern

  def log_in(user)
    cookies.signed[:user_id] = user.id
  end

  def log_out
    cookies.clear
  end

  def remember(user)
    cookies.signed[:user_id] = {
      value: user.id,
      expires: COOKIE_EXPIRY_TIME.from_now,
    }
  end

end
