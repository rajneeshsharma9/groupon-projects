require 'rails_helper'
include LoginAuthenticator

describe Admin::LocationsController, type: :controller do
  let(:admin) { FactoryBot.create(:admin) }
  let(:location) { mock_model(Location) }
  let(:address) { mock_model(Address) }
  let(:locations) { double(ActiveRecord::Relation) }
  let(:location_params) { ActionController::Parameters.new({ name: "" }).permit! }


  def find_location_by_id
    allow(Location).to receive(:find_by).with(id: location.id.to_s).and_return(location)
  end

  before do
    log_in admin
  end

  it { is_expected.to use_before_action(:find_location_by_id) }

  describe "GET #index" do
    def send_request
      get :index
    end

    before do
      allow(Location).to receive(:order).with(created_at: :desc).and_return(locations)
    end

    describe "expects to receive" do
      it { expect(Location).to receive(:order).with(created_at: :desc).and_return(locations) }
      after { send_request }
    end

    describe 'assigns' do
      before { send_request }
      it { expect(assigns(:locations)).to eq(locations) }
    end

    describe 'response' do
      before { send_request }
      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_with_layout(:admin) }
      it { expect(response).to render_template(:index) }
      it { expect(response.content_type).to eq("text/html") }
    end
  end

  describe "GET #show" do
    def send_request
      get :show, params: { id: location.id }
    end

    context "location present" do
      before { find_location_by_id }

      describe "expects to receive" do
        it { expect(Location).to receive(:find_by).with(id: location.id.to_s).and_return(location) }
        after { send_request }
      end

      describe 'assigns' do
        before { send_request }
        it { expect(assigns(:location)).to eq(location) }
      end

      describe 'response' do
        before { send_request }
        it { expect(response).to have_http_status(:ok) }
        it { expect(response).to render_with_layout(:admin) }
        it { expect(response).to render_template(:show) }
        it { expect(response.content_type).to eq("text/html") }
      end
    end

    context "location not present" do
      describe 'assigns' do
        before { send_request }
        it { expect(assigns(:location)).to be_nil }
      end

      describe 'response' do
        before { send_request }
        it { expect(response).to have_http_status(:found) }
        it { expect(response).to redirect_to(admin_locations_path) }
        it { expect(response.content_type).to eq("text/html") }
      end
    end
  end

  describe "GET #new" do
    def send_request
      get :new
    end

    before do
      allow(Location).to receive(:new).and_return(location)
      allow(location).to receive(:build_address).and_return(address)
    end

    describe "expects to receive" do
      it { expect(Location).to receive(:new).and_return(location) }
      it { expect(location).to receive(:build_address).and_return(address) }
      after { send_request }
    end

    describe 'assigns' do
      before { send_request }
      it { expect(assigns(:location)).to eq(location) }
    end

    describe 'response' do
      before { send_request }
      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_with_layout(:admin) }
      it { expect(response).to render_template(:new) }
      it { expect(response.content_type).to eq("text/html") }
    end
  end

  describe "GET #edit" do
    def send_request
      get :edit, params: { id: location.id }
    end

    context "location present" do
      before { find_location_by_id }

      describe "expects to receive" do
        it { expect(Location).to receive(:find_by).with(id: location.id.to_s).and_return(location) }
        after { send_request }
      end

      describe 'assigns' do
        before { send_request }
        it { expect(assigns(:location)).to eq(location) }
      end

      describe 'response' do
        before { send_request }
        it { expect(response).to have_http_status(:ok) }
        it { expect(response).to render_with_layout(:admin) }
        it { expect(response).to render_template(:edit) }
        it { expect(response.content_type).to eq("text/html") }
      end
    end

    context "location not present" do
      describe 'assigns' do
        before { send_request }
        it { expect(assigns(:location)).to be_nil }
      end

      describe 'response' do
        before { send_request }
        it { expect(response).to redirect_to(admin_locations_path) }
        it { expect(flash[:danger]).to eq(I18n.t('admin.locations.location_not_found')) }
        it { expect(response.content_type).to eq("text/html") }
      end
    end
  end

  describe "POST #create" do
    def send_request
      post :create, params: { location: { name: "" } }
    end

    context "with valid attributes" do
      before do
        allow(Location).to receive(:new).with(location_params).and_return(location)
        allow(location).to receive(:save).and_return(true)
      end

      describe "expects to receive" do
        it { expect(Location).to receive(:new).with(location_params).and_return(location) }
        it { expect(location).to receive(:save).and_return(true) }
        after { send_request }
      end

      describe 'assigns' do
        before { send_request }
        it { expect(assigns(:location)).to eq(location) }
      end

      describe 'response' do
        before { send_request }
        it { expect(response).to have_http_status(:found) }
        it { expect(response).to redirect_to(admin_location_path(location.id)) }
        it { expect(flash[:success]).to eq(I18n.t('admin.locations.create.location_created')) }
        it { expect(response.content_type).to eq("text/html") }
      end
    end

    context "with invalid attributes" do
      before do
        allow(Location).to receive(:new).with(location_params).and_return(location)
        allow(location).to receive(:save).and_return(false)
      end

      describe "expects to receive" do
        it { expect(Location).to receive(:new).with(location_params).and_return(location) }
        it { expect(location).to receive(:save).and_return(false) }
        after { send_request }
      end

      describe 'assigns' do
        before { send_request }
        it { expect(assigns(:location)).to eq(location) }
      end

      describe 'response' do
        before { send_request }
        it { expect(response).to have_http_status(:ok) }
        it { expect(response).to render_with_layout(:admin) }
        it { expect(response).to render_template(:new) }
        it { expect(response.content_type).to eq("text/html") }
      end
    end
  end

  describe "PATCH #update" do
    def send_request
      patch :update, params: { id: location.id, location: { name: "" } }
    end

    context "location present" do
      before { find_location_by_id }

      context "with valid attributes" do
        before do
          allow(Location).to receive(:find_by).with(id: location.id.to_s).and_return(location)
          allow(location).to receive(:update).with(location_params).and_return(true)
        end

        describe "expects to receive" do
          it { expect(Location).to receive(:find_by).with(id: location.id.to_s).and_return(location) }
          it { expect(location).to receive(:update).with(location_params).and_return(true) }
          after { send_request }
        end

        describe 'assigns' do
          before { send_request }
          it { expect(assigns(:location)).to eq(location) }
        end

        describe 'response' do
          before { send_request }
          it { expect(response).to have_http_status(:found) }
          it { expect(response).to redirect_to(admin_location_path(location.id)) }
          it { expect(flash[:success]).to eq(I18n.t('admin.locations.update.location_updated')) }
          it { expect(response.content_type).to eq("text/html") }
        end
      end

      context "with invalid attributes" do
        before do
          allow(location).to receive(:update).with(location_params).and_return(false)
        end

        describe "expects to receive" do
          it { expect(Location).to receive(:find_by).with(id: location.id.to_s).and_return(location) }
          it { expect(location).to receive(:update).with(location_params).and_return(false) }
          after { send_request }
        end

        describe 'assigns' do
          before { send_request }
          it { expect(assigns(:location)).to eq(location) }
        end

        describe 'response' do
          before { send_request }
          it { expect(response).to have_http_status(:ok) }
          it { expect(response).to render_with_layout(:admin) }
          it { expect(response).to render_template(:edit) }
          it { expect(response.content_type).to eq("text/html") }
        end
      end
    end

    context "location not present" do
      describe 'assigns' do
        before { send_request }
        it { expect(assigns(:location)).to be_nil }
      end

      describe 'response' do
        before { send_request }
        it { expect(response).to have_http_status(:found) }
        it { expect(response).to redirect_to(admin_locations_path) }
        it { expect(flash[:danger]).to eq(I18n.t('admin.locations.location_not_found')) }
        it { expect(response.content_type).to eq("text/html") }
      end
    end
  end

  describe "DELETE #destroy" do
    def send_request
      delete :destroy, params: { id: location.id }
    end

    context "location present" do
      before { find_location_by_id }

      context "location deleted" do
        before do
          allow(location).to receive(:destroy).and_return(true)
        end

        describe "expects to receive" do
          it { expect(Location).to receive(:find_by).with(id: location.id.to_s).and_return(location) }
          it { expect(location).to receive(:destroy).and_return(true) }
          after { send_request }
        end

        describe 'assigns' do
          before { send_request }
          it { expect(assigns(:location)).to eq(location) }
        end

        describe 'response' do
          before { send_request }
          it { expect(response).to have_http_status(:found) }
          it { expect(response).to redirect_to(admin_locations_path) }
          it { expect(flash[:info]).to eq(I18n.t('admin.locations.destroy.location_deleted')) }
          it { expect(response.content_type).to eq("text/html") }
        end
      end

      context "location not deleted" do
        before do
          allow(location).to receive(:destroy).and_return(false)
        end

        describe "expects to receive" do
          it { expect(Location).to receive(:find_by).with(id: location.id.to_s).and_return(location) }
          it { expect(location).to receive(:destroy).and_return(false) }
          after { send_request }
        end

        describe 'assigns' do
          before { send_request }
          it { expect(assigns(:location)).to eq(location) }
        end

        describe 'response' do
          before { send_request }
          it { expect(response).to have_http_status(:found) }
          it { expect(response).to redirect_to(admin_locations_path) }
          it { expect(flash[:danger]).to eq(I18n.t('admin.locations.error_has_occured')) }
          it { expect(response.content_type).to eq("text/html") }
        end
      end
    end

    context "location not present" do
      describe 'assigns' do
        before { send_request }
        it { expect(assigns(:location)).to be_nil }
      end

      describe 'response' do
        before { send_request }
        it { expect(response).to have_http_status(:found) }
        it { expect(response).to redirect_to(admin_locations_path) }
        it { expect(flash[:danger]).to eq(I18n.t('admin.locations.location_not_found')) }
        it { expect(response.content_type).to eq("text/html") }
      end
    end
  end
end
