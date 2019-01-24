require 'rails_helper'
include LoginAuthenticator

RSpec.describe Admin::DealsController, type: :controller do

  let(:admin) { FactoryBot.create(:admin) }
  let(:deal) { FactoryBot.create(:deal) }
  let(:category) { FactoryBot.create(:category) }
  let(:valid_deal_params) { FactoryBot.attributes_for(:deal, category_id: category.id) }
  let(:invalid_deal_params) { FactoryBot.attributes_for(:deal) }

  describe 'for logged in admin' do
    before(:each) { log_in admin }
    describe 'GET #index' do
      before { get :index }
      it 'should set deals instance variable' do
        expect(assigns(:deals)).to eq(Deal.includes(:collection).order(created_at: :desc))
      end
      it { should render_template(:index) }
      it { should respond_with(200) }
    end

    describe 'GET #show' do
      context 'for valid deal id' do
        before { get :show, params: { id: deal.id } }
        it { should use_before_action(:find_deal_by_id) }
        it { should render_template(:show) }
        it { should respond_with(200) }
      end
      context 'for invalid deal id' do
        before { get :show, params: { id: 32 } }
        it { should use_before_action(:find_deal_by_id) }
        it { should redirect_to(admin_deals_path) }
        it { should respond_with(302) }
      end
    end

    describe 'GET #new' do
      before { get :new }
      it 'should set deal instance variable' do
        expect(assigns(:deal)).to be_instance_of(Deal)
      end
      it { should render_template(:new) }
      it { should respond_with(200) }
    end

    describe 'GET #edit' do
      context 'for valid deal id' do
        before { get :edit, params: { id: deal.id } }
        it { should use_before_action(:find_deal_by_id) }
        it { should render_template(:edit) }
        it { should respond_with(200) }
      end
      context 'for invalid deal id' do
        before { get :edit, params: { id: 32 } }
        it { should use_before_action(:find_deal_by_id) }
        it { should redirect_to(admin_deals_path) }
        it { should respond_with(302) }
      end
    end

    describe 'POST #create' do
      describe 'when deal is created successfully' do
        before { post :create, params: { deal: valid_deal_params } }
        it 'should set deal instance variable' do
          expect(assigns(:deal)).to be_instance_of(Deal)
        end
        it { should redirect_to(admin_deal_path(controller.instance_variable_get(:@deal))) }
        it { should set_flash[:info] }
        it { should respond_with(302) }
      end
      describe 'when deal is not created successfully' do
        before { post :create, params: { deal: invalid_deal_params } }
        it 'should set deal instance variable' do
          expect(assigns(:deal)).to be_instance_of(Deal)
        end
        it { should set_flash.now[:danger] }
        it { should render_template(:new) }
      end
    end

    describe 'PATCH #update' do
      describe 'when deal is updated successfully' do
        before { patch :update, params: { deal: { category_id: category.id }, id: deal.id } }
        it { should use_before_action(:find_deal_by_id) }
        it { should redirect_to(admin_deal_path(controller.instance_variable_get(:@deal))) }
        it { should set_flash[:success] }
        it { should respond_with(302) }
      end
      describe 'when deal is not updated successfully' do
        before { patch :update, params: { deal: { category_id: nil }, id: deal.id } }
        it { should use_before_action(:find_deal_by_id) }
        it { should render_template(:edit) }
        it { should set_flash.now[:danger] }
      end
    end

    describe 'DELETE #destroy' do
      describe 'when deal is destroyed successfully' do
        before { delete :destroy, params: { id: deal.id } }
        it { should use_before_action(:find_deal_by_id) }
        it { should redirect_to(admin_deals_path) }
        it { should set_flash[:success] }
        it { should respond_with(302) }
      end
    end

    describe 'PUT #publish' do
      describe 'when deal is not published successfully' do
        before { put :publish, params: { id: deal.id } }
        it { should use_before_action(:find_deal_by_id) }
        it 'returns json as response' do
          expect(response.content_type).to eq('application/json')
        end
        it 'returns json with errors present in body' do
          expect(response.body).to include('errors')
        end
        it { should respond_with(422) }
      end
    end

    describe 'PUT #unpublish' do
      describe 'when deal is unpublished successfully' do
        before { put :unpublish, params: { id: deal.id } }
        it { should use_before_action(:find_deal_by_id) }
        it 'returns json as response' do
          expect(response.content_type).to eq('application/json')
        end
        it 'returns json with deal id present in body' do
          expect(response.body).to include('id')
        end
        it { should respond_with(200) }
      end
    end

  end

end
