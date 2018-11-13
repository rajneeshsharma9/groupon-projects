class ApplicationController < ActionController::Base

  add_flash_types :danger, :success, :info

  before_action :authorize

  helper_method :current_user, :logged_in?

  private def logged_in?
    current_user.present?
  end
  
  private def authorize
    unless logged_in?
      redirect_to login_path, info: t('login_message')
    end
  end

  private def current_user
    if user_id = cookies.signed[:user_id]
      @current_user ||= User.find_by(id: user_id)
    end
  end

  private def ensure_logged_out
    if logged_in?
      redirect_to home_page_path, info: t('logout_message')
    end
  end

end
