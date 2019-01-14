require 'rails_helper'

shared_examples_for "authenticator" do
  let(:model) { FactoryBot.create(described_class.to_s.underscore.to_sym) }

  describe "Instance methods" do
    describe "response to instance methods" do
      [:verify_email, :activated?, :authenticated_token?, :set_reset_digest, :send_password_reset_email, :password_reset_expired?].each do |instance_method|
        it "responds to #{ instance_method }" do
          expect(model).to respond_to(instance_method)
        end
      end
    end
    describe "verify_email" do
      it "updates verification_token column of model" do
        model.verify_email
        expect(model.verification_token).to be_nil
      end
      it "updates verified_at column of model" do
        model.update_columns(verified_at: nil)
        model.verify_email
        expect(model.verified_at).not_to be_nil
      end
    end
    describe "activated?" do
      context "when verified_at is present" do
        it "returns true" do
          model.update_columns(verified_at: Time.current)
          expect(model.activated?).to be true
        end
      end
      context "when verified_at is not present" do
        it "returns false" do
          model.update_columns(verified_at: nil)
          expect(model.activated?).to be false
        end
      end
    end
    describe "set_reset_digest" do
      it "sets reset_digest" do
        model.update_columns(reset_digest: nil)
        model.set_reset_digest
        expect(model.reset_digest).not_to be_nil
      end
      it "sets reset_sent_at" do
        model.update_columns(reset_sent_at: nil)
        model.set_reset_digest
        expect(model.reset_sent_at).not_to be_nil
      end
    end
    describe "authenticated_token?" do
      context "when valid token" do
        it "returns true" do
          model.set_reset_digest
          expect(model.authenticated_token?("reset", model.reset_token)).to be true
        end
      end
      context "when invalid token" do
        it "returns false" do
          model.set_reset_digest
          expect(model.authenticated_token?("reset", "abc")).to be false
        end
      end
    end
  end

end
