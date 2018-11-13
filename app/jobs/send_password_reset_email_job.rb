class SendPasswordResetEmailJob < ActiveJob::Base

  def perform(user_id, reset_token)
    UserMailer.send_password_reset_email(user_id, reset_token).deliver_now
  end

end
