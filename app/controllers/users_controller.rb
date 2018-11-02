class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.customer.new(user_params)
    if @user.save
      redirect_to home_page_url, notice: t('.confirm_email_message')
    else
      render :new
    end
  end

  def confirm_email
    user = User.find_by_verification_token(params[:token])
    if user
      user.verify_email
      flash[:notice] = t('.welcome_email_message')
      redirect_to home_page_url
    else
      redirect_to home_page_url, notice: t('.no_user_exists')
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation, :email)
    end

end
