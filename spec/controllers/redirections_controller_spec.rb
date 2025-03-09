require 'rails_helper'

RSpec.describe RedirectionsController, type: :controller do
  let(:redirection) { create(:redirection) }
  let(:valid_attributes) { attributes_for(:redirection) }
  let(:redirection_pattern) {
    {
      id: Integer,
      target_key: String,
      secret_key: String,
      target_url: String,
      short_url: String,
      expire_at: nil,
      requisition_count: Integer,
      created_at: ::Types::I18nDateTime,
      updated_at: ::Types::I18nDateTime,
    }
  }
  let(:requisition_pattern) {
    {
      id: Integer,
      redirection_id: Integer,
      action_type: String,
      remote_ip: String,
      user_agent: String,
      metadata: nil,
      created_at: ::Types::I18nDateTime,
      updated_at: ::Types::I18nDateTime,
    }
  }

  describe 'POST #create' do
    context 'successful' do
      it 'when use valid params' do
        post :create, params: valid_attributes

        expect(response.body).to be_json_as(redirection_pattern)
        expect(response).to have_http_status(:created)

        expect(Redirection.count).to eq(1)
        expect(Requisition.count).to eq(1)
      end
      it 'when use valid expire_at' do
        valid_attributes[:expire_at] = 1.day.from_now
        redirection_pattern[:expire_at] = ::Types::I18nDateTime

        post :create, params: valid_attributes

        expect(response.body).to be_json_as(redirection_pattern)
        expect(response).to have_http_status(:created)

        expect(Redirection.count).to eq(1)
        expect(Requisition.count).to eq(1)
      end
    end

    context 'failure' do
      it 'when target_url point to APP_HOST' do
        valid_attributes[:target_url] = Redirection::APP_HOST
        pattern = {
          target_url: [I18n.t('errors.redirection.self_target_url')]
        }

        post :create, params: valid_attributes

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to be_json_as(pattern)
      end

      it 'when target_url already exists' do
        valid_attributes[:target_url] = redirection.target_url
        pattern = {
          target_url: [I18n.t('errors.redirection.target_url_already_exists')]
        }

        post :create, params: valid_attributes

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to be_json_as(pattern)
      end

      it 'when expire_at is passed' do
        valid_attributes[:expire_at] = 1.day.ago
        pattern = {
          expire_at: [I18n.t('errors.redirection.expire_at_is_passed')]
        }

        post :create, params: valid_attributes

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to be_json_as(pattern)
      end

      it 'when target_url no send' do
        pattern = { target_url: [I18n.t('dry_validation.errors.key?')] }
        valid_attributes.delete(:target_url)

        post :create, params: valid_attributes

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to be_json_as(pattern)
      end

      it 'when target_url is nil' do
        pattern = { target_url: [I18n.t('dry_validation.errors.filled?')] }
        valid_attributes[:target_url] = nil

        post :create, params: valid_attributes

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to be_json_as(pattern)
      end

      it 'when target_url is invalid' do
        pattern = { target_url: [I18n.t('dry_validation.errors.format?')] }
        valid_attributes[:target_url] = 'invalid'

        post :create, params: valid_attributes

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to be_json_as(pattern)
      end

      it 'when expire_at is invalid' do
        pattern = { expire_at: [I18n.t('dry_validation.errors.date?')] }
        valid_attributes[:expire_at] = 'invalid'

        post :create, params: valid_attributes

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to be_json_as(pattern)
      end
    end
  end

  describe 'GET #show' do
    context 'successful' do
      it 'when use valid url' do
        expect {
          get :show, params: { target_key: redirection.target_key }
        }.to change(Requisition, :count).by(1)

        expect(response).to redirect_to(redirection.target_url)

        redirection.reload

        expect(redirection.requisition_count).to eq(1)
      end
      it 'when redirection have a expire_at valid' do
        redirection.update!(expire_at: Time.zone.today)

        expect {
          get :show, params: { target_key: redirection.target_key }
        }.to change(Requisition, :count).by(1)

        expect(response).to redirect_to(redirection.target_url)

        redirection.reload

        expect(redirection.requisition_count).to eq(1)
      end
    end

    context 'failure' do
      it 'when redirection is expired' do
        redirection.update!(expire_at: Time.zone.yesterday)
        pattern = { error: [I18n.t('errors.not_found')] }

        get :show, params: { target_key: redirection.target_key }

        expect(response).to have_http_status(:not_found)
        expect(response.body).to be_json_as(pattern)
      end

      it 'when target_key is invalid' do
        pattern = { error: [I18n.t('errors.not_found')] }

        get :show, params: { target_key: 'invalid' }

        expect(response).to have_http_status(:not_found)
        expect(response.body).to be_json_as(pattern)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'successful' do
      it 'when use valid secret_key' do
        expect {
          delete :destroy, params: { secret_key: redirection.secret_key }
        }.to change(Requisition, :count).by(1)

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'failure' do
      it 'when secret_key is invalid' do
        pattern = { error: [I18n.t('errors.not_found')] }

        delete :destroy, params: { secret_key: 'invalid' }

        expect(response).to have_http_status(:not_found)
        expect(response.body).to be_json_as(pattern)
      end
    end
  end
end
