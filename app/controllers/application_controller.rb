class ApplicationController < ActionController::Base
  
  add_flash_types :danger, :success, :info
  helper_method :current_user, :logged_in?

  before_action :authorize

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    else
      @current_user = nil
    end
  end

  def logged_in?
    current_user != nil
  end

  def authorize
    unless User.find_by(id: session[:user_id])
      redirect_to login_path, info: 'Please log in'
    end
  end

end
