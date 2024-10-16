# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users' do
  describe 'GET /users/:id' do
    context 'ユーザーが存在する場合' do
      let!(:user) { create(:user) }

      it '200が返ること' do
        get "/users/#{user.id}"

        expect(response).to have_http_status(:ok)
      end

      it 'ユーザーID,ユーザー名が返ること' do
        get "/users/#{user.id}"

        json_response = response.parsed_body
        expect(json_response['id']).to eq(user.id)
        expect(json_response['name']).to eq(user.name)
      end
    end

    context 'ユーザーが存在しない場合' do
      it '404が返ること' do
        get '/users/1'

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
