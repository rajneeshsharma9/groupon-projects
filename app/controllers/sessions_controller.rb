class SessionsController < ApplicationController

  include LoginAuthenticator

  before_action :find_user_by_email,     only: %i[create]
  before_action :ensure_logged_out_user, except: %i[destroy]
  skip_before_action :authorize,         only: %i[new create]

  def new; end

  def create
    if @user.authenticate(params[:password]) && @user.activated?
      log_in @user
      redirect_to home_page_path(@user), success: t('.login_successful')
    elsif @user.authenticate(params[:password]) && !@user.activated?
      flash.now[:danger] = t('.inactive_user')
      render :new
    else
      flash.now[:danger] = t('.invalid_password')
      render :new
    end
  end

  def destroy
    log_out
    redirect_to home_page_path, info: t('.logged_out')
  end

  private def find_user_by_email
    @user = User.find_by(email: params[:email])
    redirect_to login_path, danger: t('.invalid_email') if @user.nil?
  end

  private def ensure_logged_out_user
    if logged_in?
      redirect_to home_page_path, info: t('logout_message')
    end
  end

end
