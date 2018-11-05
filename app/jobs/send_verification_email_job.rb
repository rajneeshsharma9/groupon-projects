class SendVerificationEmailJob < ActiveJob::Base

  queue_as :user_verification_emails

  def perform(user_id)
    UserMailer.send_verification_email(user_id).deliver_now
  end

end
