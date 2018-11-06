class SessionsController < ApplicationController

  skip_before_action :authorize

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to dashboard_user_path(user), success: t('.login_successful')
    else
      flash.now[:danger] = t('.invalid_password')
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to home_page_path, info: t('.logged_out')
  end

end 
