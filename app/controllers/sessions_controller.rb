class SessionsController < ApplicationController

  before_action :find_user_by_email, only: [:create]
  skip_before_action :authorize, only: [:new, :create]

  def new; end

  def create
    
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to dashboard_user_path(@user), success: t('.login_successful')
    else
      flash.now[:danger] = t('.invalid_password')
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to home_page_path, info: t('.logged_out')
  end

  private

    def find_user_by_email
      @user = User.find_by(email: params[:email])
    end

end 
