class UserMailer < ApplicationMailer

  def send_verification_email(user_id)
    @user = User.find_by(id: user_id)
    if @user
      mail to: @user.email, subject: t('.sign_up_mail_subject')
    end
  end

  def send_password_reset_email(user_id, reset_token)
    @user = User.find_by(id: user_id)
    @user.reset_token = reset_token
    if @user
      mail to: @user.email, subject: t('.reset_mail_subject')
    end
  end

end
