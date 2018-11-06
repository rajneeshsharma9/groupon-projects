class UsersController < ApplicationController

  before_action :set_user_by_token, only: [:confirm_account]
  skip_before_action :authorize, only: [:new, :create, :confirm_account]

  def new
    @user = User.new
  end

  def dashboard
  end

  def create
    @user = User.customer.new(user_params)
    if @user.save
      redirect_to home_page_path, info: t('.confirm_account_message')
    else
      render :new
    end
  end

  def confirm_account
    if @user.verify_email
      redirect_to login_path, success: t('.welcome_email_message') 
    else
      redirect_to home_page_path, danger: t('.unknown_error')
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation, :email)
    end

    def set_user_by_token
      @user = User.find_by(verification_token: params[:token])
      if @user.nil?
        redirect_to home_page_path, danger: t('.wrong_link')
      end
    end

end
