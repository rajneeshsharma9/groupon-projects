require 'rails_helper'

RSpec.describe Order, type: :model do

  let(:order_instance) { FactoryBot.create(:order) }

  describe "attr accessors" do
    context 'current_user' do
      before { order_instance.current_user = true }
      it 'responds to attibute getter' do
        expect(order_instance).to respond_to(:current_user)
      end
      it 'has attribute setter' do
        expect(order_instance.current_user).to be true
      end
    end
  end

  describe "Associations" do
    it { should have_one(:billing_address).class_name('Address').dependent(:destroy).validate(true) }
    it { should belong_to(:user) }
    it { should have_many(:line_items).dependent(:destroy) }
    it { should have_many(:deals).through(:line_items) }
    it { should have_one(:payment).dependent(:destroy) }
  end

  describe "Validations" do
    it do
      should validate_numericality_of(:amount).
        is_less_than_or_equal_to(99999.99).
        is_greater_than_or_equal_to(0.00).
        allow_nil
    end
    it do
      should allow_value('wefwe@gmail.com').
        for(:receiver_email).
        with_message('Invalid Email')
      should_not allow_value('dwef').
        for(:receiver_email)
    end
  end

  describe "Calbacks" do
    it { is_expected.to callback(:reset_state).before(:update_cart) }
    it { is_expected.to callback(:check_if_deal_expired).before(:update_cart) }
    it { is_expected.to callback(:check_if_deal_unpublished).before(:update_cart) }
    it { is_expected.to callback(:update_price).after(:update_cart) }
  end

  describe "Instance methods" do
    describe "#update_cart" do
      context "when adding line item of same deal" do
        let!(:line_item) { FactoryBot.create(:line_item, order: order_instance) }
        before do
          deal = line_item.deal
          order_instance.update_cart({ task: 'increment' }, deal, line_item)
        end
        it "does not increase the line_item count" do
          expect(order_instance.line_items.count).to eq(1)
        end
        it "increases line_item quantity" do
          expect(order_instance.line_items.first.quantity - line_item.quantity).to eq(1)
        end
      end
      context "when removing line item of same deal" do
        let!(:line_item) { FactoryBot.create(:line_item, order: order_instance) }
        let!(:previous_value) { line_item.quantity }
        before do
          deal = line_item.deal
          order_instance.update_cart({ task: 'decrement' }, deal, line_item)
        end
        it "does not decrease the line_item count" do
          expect(order_instance.line_items.count).to eq(1)
        end
        it "decreases line_item quantity" do
          expect(previous_value - order_instance.line_items.first.quantity).to eq(1)
        end
      end
      context "when decrementing line item with 1 quantity" do
        before do
          line_item = FactoryBot.create(:line_item, order: order_instance, quantity: 1)
          deal = line_item.deal
          order_instance.update_cart({ task: 'decrement' }, deal, line_item)
        end
        it "destroys line_item" do
          expect(order_instance.line_items.count).to eq(0)
        end
      end
    end
    describe "#total_price" do
      context "when line_items are not present" do
        it "has zero total price value" do
          expect(order_instance.total_price).to eq(0)
        end
      end
      context "when line_items are present" do
        before { FactoryBot.create(:line_item, order: order_instance) }
        it "has positive total price value" do
          expect(order_instance.total_price).to be > 0
        end
      end
    end
    describe "#update_price" do
      it "is defined as a private method" do
        expect(order_instance.private_methods).to include(:update_price)
      end
    end
    describe "#reset_state" do
      it "is defined as a private method" do
        expect(order_instance.private_methods).to include(:reset_state)
      end
    end
  end

end
