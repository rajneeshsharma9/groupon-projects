class UserMailer < ActionMailer::Base
  
  default from: 'super@groupon.com'

  def send_verification_email(user_id)
    @user = User.find(user_id)
    mail(to: @user.email, subject: "Registration Confirmation for Groupon App")
  end

end
