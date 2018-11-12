module LoginAuthenticator
  
  include ActiveSupport::Concern

  def log_in(user)
    if params[:remember_me] == 'on'
      remember(user)
    else  
      cookies.signed[:user_id] = user.id
    end
  end

  def log_out
    reset_session
    cookies.clear
  end

  def remember(user)
    cookies.signed[:user_id] = {
      value: user.id,
      expires: COOKIE_EXPIRY_TIME.from_now,
    }
  end

end
