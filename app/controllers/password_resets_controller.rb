class PasswordResetsController < ApplicationController

  before_action :find_user_by_email,           only: %i[edit update]
  before_action :find_user_by_reset_email,     only: %i[create]
  before_action :validate_user_authentication, only: %i[edit]
  before_action :check_expiration,             only: %i[edit update]
  before_action :ensure_logged_out,            only: %i[new]
  skip_before_action :authorize,               only: %i[new create edit update]

  def new
    flash.now[:info] = t('.enter_email')
  end

  def create
    if @user.set_reset_digest
      redirect_to home_page_path, info: t('.email_sent')
    else
      redirect_to home_page_path, danger: t('.error_has_occured')
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to login_path, success: t('.password_reset')
    else
      flash.now[:danger] = t('.error_has_occured')
      render 'edit'
    end
  end

  private def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  private def find_user_by_email
    @user = User.find_by(email: params[:email])
    if @user.nil?
      flash.now[:danger] = t('.email_invalid')
      render 'new'
    end
  end

  private def validate_user_authentication
    unless @user.activated? && @user.authenticated_token?(:reset, params[:token])
      redirect_to home_page_path, danger: t('.invalid_user')
    end
  end

  private def find_user_by_reset_email
    @user = User.find_by(email: params[:password_reset][:email])
    if @user.nil?
      flash.now[:danger] = t('.email_invalid')
      render 'new'
    end
  end

  private def check_expiration
    if @user.password_reset_expired?
      redirect_to new_password_reset_path, danger: t('.reset_expired')
    end
  end

end
