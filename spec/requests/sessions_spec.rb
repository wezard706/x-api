# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions' do
  describe 'POST /sessions' do
    subject { post '/sessions', params: params.to_json, headers: }

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
