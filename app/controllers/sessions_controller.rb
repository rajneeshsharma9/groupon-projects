class SessionsController < ApplicationController

  before_action :find_user_by_email, only: [:create]
  before_action :set_user_by_id,     only: [:destroy]
  skip_before_action :authorize,     only: [:new, :create]

  def new; end

  def create
    if @user && @user.authenticate(params[:password])
      log_in @user
      params[:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_to dashboard_user_path(@user), success: t('.login_successful')
    else
      flash.now[:danger] = t('.invalid_password')
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to home_page_path, info: t('.logged_out')
  end

  private

    def find_user_by_email
      @user = User.find_by(email: params[:email])
    end

    def log_out
      session.delete(:user_id)
      forget(@user)
    end

    def remember(user)
      user.remember
      cookies.permanent.signed[:user_id] = user.id
      cookies.permanent[:remember_token] = user.remember_token
    end

    def forget(user)
      user.forget
      cookies.delete(:user_id)
      cookies.delete(:remember_token)
    end

    def set_user_by_id
      @user = User.find_by(id: session[:user_id])
    end
end 
