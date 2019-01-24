module LoginAuthenticator

  extend ActiveSupport::Concern

  def log_in(user)
    cookies.signed[:user_id] = cookie_hash(user)
  end

  def log_out
    reset_session
    cookies.clear
  end

  def cookie_hash(user)
    if request.params[:remember_me] == 'on'
      {
        value: user.id,
        expires: COOKIE_EXPIRY_TIME.from_now
      }
    else
      { value: user.id }
    end
  end

end
