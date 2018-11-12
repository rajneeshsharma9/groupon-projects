class SessionsController < ApplicationController

  include LoginAuthenticator
  before_action :find_user_by_email, only: [:create]
  skip_before_action :authorize,     only: [:new, :create]

  def new; end

  def create
    if @user.authenticate(params[:password]) && @user.activated?
      log_in @user
      if params[:remember_me] == 'on'
        remember(@user)
      end
      redirect_to dashboard_user_path(@user), success: t('.login_successful')
    elsif @user.authenticate(params[:password]) && !@user.activated?
      flash.now[:danger] = t('.inactive_user')
      render :new
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
      if @user.nil?
        redirect_to login_path, danger: t('.invalid_email') 
      end
    end
end 
