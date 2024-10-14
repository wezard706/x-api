# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Auth' do
  describe 'POST /sign_up' do
    subject { post '/sign_up', params: valid_params.to_json, headers: }

    let!(:headers) do
      { 'Content-Type' => 'application/json' }
    end

    context 'パラメータが正しい場合' do
      let!(:valid_params) do
        {
          username: 'test_user',
          email: 'test@example.com',
          password: 'password',
          password_confirmation: 'password'
        }
      end

      it '201が返ること' do
        subject
        expect(response).to have_http_status(:created)
      end
    end

    context 'パラメータが不正な場合' do
      let!(:valid_params) do
        {
          username: 'test_user',
          email: 'test@example.com',
          password: 'password',
          password_confirmation: 'no_match'
        }
      end

      it '422が返ること' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'エラーメッセージが返ること' do
        subject

        json_response = response.parsed_body
        expect(json_response['errors']).to eq [
          {
            'message' => '確認用のパスワードとパスワードの入力が一致しません'
          }
        ]
      end
    end
  end

  describe 'POST /sign_in' do
    subject { post '/sign_in', params: params.to_json, headers: }

    let!(:headers) do
      { 'Content-Type' => 'application/json' }
    end

    let!(:params) do
      {
        email: Faker::Internet.email,
        password: Faker::Internet.password
      }
    end

    let!(:user) do
      create(:user,
             email: params[:email],
             password: params[:password])
    end

    it '200が返ること' do
      subject
      expect(response).to have_http_status(:ok)
    end

    it 'ユーザーID、ユーザー名、トークンが返ること' do
      subject

      json_response = response.parsed_body
      expect(json_response['user_id']).to eq(user.id)
      expect(json_response['user_name']).to eq(user.name)
      expect(json_response['token']).to be_present
    end
  end
end
