class ApplicationMailer < ActionMailer::Base
  default from: ENV['DEFAULT_SENDER_EMAIL']
  layout 'mailer'
end
