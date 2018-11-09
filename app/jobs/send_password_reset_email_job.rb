class SendPasswordResetEmailJob < ActiveJob::Base

  queue_as :default

  def perform(user_id, reset_token)
    UserMailer.send_password_reset_email(user_id, reset_token).deliver_now
  end

end
