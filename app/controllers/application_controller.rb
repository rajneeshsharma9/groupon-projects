class ApplicationController < ActionController::Base
  
  add_flash_types :danger, :success, :info
  helper_method :current_user, :logged_in?

  before_action :authorize

  private

    def current_user
      if session[:user_id]
        @current_user ||= User.find_by(id: session[:user_id])
      else
        @current_user
      end
    end
  
    def logged_in?
      current_user.present?
    end
  
    def authorize
      unless logged_in?
        redirect_to login_path, info: t('login_message')
      end
    end

end
