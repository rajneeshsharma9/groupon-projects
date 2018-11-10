class PasswordResetsController < ApplicationController

  before_action :set_user,           only: [:edit, :update]
  before_action :find_user_by_email, only: [:create]
  before_action :validate_user,      only: [:edit]
  before_action :check_expiration,   only: [:edit, :update]
  skip_before_action :authorize,     only: [:new, :create, :edit, :update]

  def new
    flash.now[:info] = t('.enter_email')
  end

  def create
    if @user
      @user.set_reset_digest
      @user.send_password_reset_email
      flash[:info] = t('.email_sent')
      redirect_to home_page_path
    else
      flash.now[:danger] = t('.email_invalid')
      render 'new'
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t('.required'))
      render 'edit'
    elsif @user.update_attributes(user_params)
      redirect_to login_path, success: t('.password_reset')
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def set_user
      @user = User.find_by(email: params[:email])
    end

    def validate_user
      unless (@user.activated? && @user.authenticated?(:reset, params[:token]))
        redirect_to home_page_path, danger: t('.invalid_user')
      end
    end

    def find_user_by_email
      @user = User.find_by(email: params[:password_reset][:email])
    end

    def check_expiration
      if @user.password_reset_expired?
        redirect_to new_password_reset_path, danger: t('.reset_expired')
      end
    end

end
