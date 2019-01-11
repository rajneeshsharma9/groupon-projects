require 'rails_helper'

RSpec.describe Deal, type: :model do

  let(:deal_instance) { FactoryBot.create(:deal) }

  describe 'constants' do
    it 'has MAXIMUM_ALLOWED_IMAGE_SIZE defined' do
      expect(Deal.const_defined?("MAXIMUM_ALLOWED_IMAGE_SIZE")).to be true
    end
    it 'has MINIMUM_IMAGE_COUNT defined' do
      expect(Deal.const_defined?("MINIMUM_IMAGE_COUNT")).to be true
    end
    it 'has MINIMUM_LOCATION_COUNT defined' do
      expect(Deal.const_defined?("MINIMUM_LOCATION_COUNT")).to be true
    end
  end

  describe 'attribute accessors' do
    context 'published_from_collection' do
      it 'responds to attibute getter' do
        expect(deal_instance).to respond_to(:published_from_collection)
      end
      it 'has attibute setter' do
        deal_instance.published_from_collection = true
        expect(deal_instance.published_from_collection).to be true
      end
    end
  end

  describe "Associations" do
    describe "has_many" do
      context "line items" do
        it "responds to line_items method" do
          expect(deal_instance).to respond_to(:line_items)
        end
        it "returns 0 when no line items present" do
          expect(deal_instance.line_items.count).to eq(0)
        end
      end
    end
    describe "belongs_to" do
      context "category" do
        it "responds to category method" do
          expect(deal_instance).to respond_to(:category)
        end
        it "returns category when category present" do
          expect(deal_instance.category).to be_instance_of(Category)
        end
        it "cannot be saved when category not present" do
          deal_instance.category = nil
          deal_instance.valid?
          expect(deal_instance.errors[:category]).to include("must exist")
        end
      end
      context "collection" do
        it "responds to collection method" do
          expect(deal_instance).to respond_to(:collection)
        end
        it "returns nil when collection not present" do
          expect(deal_instance.collection).to be_nil
        end
        it "can be saved when collection not present" do
          deal_instance.collection = nil
          deal_instance.valid?
          expect(deal_instance.errors[:collection]).not_to include("must exist")
        end
      end
    end

  end

  describe 'Callbacks' do
    describe 'after create validate_start_at' do
      subject { FactoryBot.build(:deal) }
      it 'defines validate_start_at as a private method' do
        expect(subject.private_methods).to include(:validate_start_at)
      end
      it 'does not trigger validate_start_at before creation' do
        expect(subject).not_to receive(:validate_start_at)
      end
      it 'triggers validate_start_at after creation' do
        expect(subject).to receive(:validate_start_at)
        subject.save
      end
    end

    describe 'before update purge_images' do
      it 'defines purge_images as a private method' do
        expect(subject.private_methods).to include(:purge_images)
      end
      it 'triggers purge_images before update' do
        expect(deal_instance).to receive(:purge_images)
        deal_instance.update(description: 'efwef')
      end
    end
  end

  describe "Validations" do
    describe "Presence" do
      [:title, :start_at, :expire_at, :price].each do |attribute|
        describe "#{attribute}" do
          context "when attribute is not present" do
            it "has presence validation error" do
              deal_instance[attribute] = ""
              deal_instance.valid?
              expect(deal_instance.errors[attribute]).to include("can't be blank")
            end
          end
          context "when attribute is present" do
            subject { FactoryBot.build(:deal) }
            it "does not have presence validation error" do
              subject.valid?
              expect(subject.errors[attribute]).not_to include("can't be blank")
            end
          end
        end
      end
    end

    describe "Uniqueness" do
      let(:deal_instance_two) { Deal.new }
      [:title].each do |attribute|
        describe "#{attribute}" do
          context "when attribute is not unique" do
            it "has uniqueness validation error" do
              deal_instance_two[attribute] = deal_instance[attribute]
              deal_instance_two.valid?
              expect(deal_instance_two.errors[attribute]).to include("has already been taken")
            end
          end
          context "when attribute is unique" do
            it "does not have uniqueness validation error" do
              deal_instance_two[attribute] = SecureRandom.urlsafe_base64.to_s
              deal_instance_two.valid?
              expect(deal_instance_two.errors[attribute]).not_to include("has already been taken")
            end
          end
          context "when attribute is not present" do
            it "does not have uniqueness validation error" do
              deal_instance_two[attribute] = ""
              deal_instance_two.valid?
              expect(deal_instance_two.errors[attribute]).not_to include("has already been taken")
            end
          end
        end
      end
    end

    describe "Numericality" do
      describe "Price" do
        context "when less than minimum allowed price" do
          it "has minimum numericality validation error" do
            deal_instance[:price] = -20.0
            deal_instance.valid?
            expect(deal_instance.errors[:price]).to include("must be greater than or equal to 0.01")
          end
        end
        context "when greater than maximum allowed price" do
          it "has maximum numericality validation error" do
            deal_instance[:price] =  9999999.99
            deal_instance.valid?
            expect(deal_instance.errors[:price]).to include("must be less than or equal to 9999.99")
          end
        end
        context "when between the allowed price range" do
          it "does not have numericality validation error" do
            deal_instance[:price] =  999.9
            deal_instance.valid?
            expect(deal_instance.errors[:price]).not_to include("must be less than or equal to 9999.99")
          end
        end
        context "when price is not present" do
          it "does not have numericality validation error" do
            deal_instance[:price] = ""
            deal_instance.valid?
            expect(deal_instance.errors[:price]).not_to include("must be greater than or equal to 0.01")
          end
        end
      end
    end

    describe "Date range" do
      describe "start_at" do
        context "when creating new record" do
          let(:new_deal_instance) { FactoryBot.build(:deal) }
          context "when start_at is less than current_time" do
            it "has date range validation error" do
              new_deal_instance[:start_at] = Time.current - 1.hour
              new_deal_instance.valid?
              expect(new_deal_instance.errors[:start_at]).to include("cannot be less than the current time")
            end
          end
          context "when start_at is more than current" do
            it "does not have date range validation error" do
              new_deal_instance[:start_at] = Time.current + 1.hour
              new_deal_instance.valid?
              expect(new_deal_instance.errors[:start_at]).not_to include("cannot be less than the current time")
            end
          end
        end
        context "when updating persisted record" do
          context "when start_at is less than created_at" do
            it "has date range validation error" do
              deal_instance[:start_at] = deal_instance[:created_at] - 1.hour
              deal_instance.valid?
              expect(deal_instance.errors[:start_at]).to include("cannot be less than the Created at")
            end
          end
          context "when start_at is more than created_at" do
            it "does not have date range validation error" do
              deal_instance[:start_at] = deal_instance[:created_at] + 1.hour
              deal_instance.valid?
              expect(deal_instance.errors[:start_at]).not_to include("cannot be less than the Created at")
            end
          end
        end
      end
    end

    describe "Custom Validations" do
      describe "check_publishability" do
        it "has check_publishability as a private method" do
          expect(deal_instance.private_methods).to include(:check_publishability)
        end
        context "when updating pubslished_at of persisted record" do
          context "when location, image and collection are not present" do
            it "contains errors at base" do
              deal_instance.published_at = Time.current
              deal_instance.valid?
              expect(deal_instance.errors[:base]).to include("cannot be published as location is not present")
            end
          end
        end
        context "when creating new record" do
          let(:new_deal_instance) { FactoryBot.build(:deal) }
          context "when location, image and collection are not present" do
            it "does not contain errors at base" do
              new_deal_instance.published_at = Time.current
              new_deal_instance.valid?
              expect(new_deal_instance.errors[:base]).not_to include("cannot be published as location is not present")
            end
          end
        end
      end
      describe "check_if_live_or_expired" do
        context "when updating published record" do
          it "contains cannot be updated error" do
            deal_instance.update_columns(published_at: Time.current)
            deal_instance.update(title: Faker::Name.name)
            expect(deal_instance.errors[:base]).to include("Live or expired deals cannot be updated")
          end
        end
        context "when updating unpublished record" do
          it "does not contain cannot be updated error" do
            deal_instance.update(title: Faker::Name.name)
            expect(deal_instance.errors[:base]).not_to include("Live or expired deals cannot be updated")
          end
        end
      end
    end

  end

  describe "Scopes" do
    describe "published" do
      it "has scope as class method" do
        expect(Deal.methods(false).include?(:published)).to be true
      end
      it "has arel as return type" do
        expect(Deal.published.class.name).to eq("ActiveRecord::Relation")
      end
      it "returns only published records" do
        expect(Deal.published.select{ |deal| deal.published_at.present? }.count).to eq(Deal.published.count)
      end
    end
  end

  describe "Instance methods" do
    describe "published?" do
      it "responds to published? method" do
        expect(deal_instance).to respond_to(:published?)
      end
      context "for published record" do
        it "returns true" do
          deal_instance.update_columns(published_at: Time.current)
          expect(deal_instance.published?).to be true
        end
      end
      context "for unpublished record" do
        it "returns false" do
          expect(deal_instance.published?).to be false
        end
      end
    end
    describe "expired?" do
      it "responds to expired? method" do
        expect(deal_instance).to respond_to(:expired?)
      end
      context "expired record" do
        it "returns true" do
          deal_instance.update_columns(expire_at: Time.current - 1.hour)
          expect(deal_instance.expired?).to be true
        end
      end
      context "for live record" do
        it "returns false" do
          deal_instance.update_columns(expire_at: Time.current + 1.hour)
          expect(deal_instance.expired?).to be false
        end
      end
    end
  end

end
