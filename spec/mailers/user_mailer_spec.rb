require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'send_verification_email' do
    let(:user) { FactoryBot.create(:user) }
    let(:mail) { UserMailer.send_verification_email(user.id).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq(I18n.t('user_mailer.send_verification_email.sign_up_mail_subject'))
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['super@groupon.com'])
    end

    it 'has user name in body' do
      expect(mail.body.encoded).to match(user.name)
    end

    it 'sends correct confirm_account_url in body' do
      expect(mail.body.encoded)
        .to match("http://localhost:3000/#{ user.verification_token }")
    end

  end
end
