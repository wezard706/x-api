# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users' do
  include_context 'header'

  describe 'GET /users/:id' do
    context 'ユーザーが存在する場合' do
      context 'プロフィール画像が存在する場合' do
        let!(:user) { create(:user, :with_profile_image) }

        it '200が返ること' do
          get("/users/#{user.id}", headers:)

          expect(response).to have_http_status(:ok)
        end

        it 'ユーザーID,ユーザー名が返ること' do
          get("/users/#{user.id}", headers:)

          json_response = response.parsed_body
          expect(json_response).to eq({
                                        'id' => user.id,
                                        'name' => user.name,
                                        'follower_count' => 0,
                                        'following_count' => 0,
                                        'profile_image_url' => user.profile_image_url
                                      })
        end
      end

      context 'プロフィール画像が存在しない場合' do
        let!(:user) { create(:user) }

        it '200が返ること' do
          get("/users/#{user.id}", headers:)

          expect(response).to have_http_status(:ok)
        end

        it 'ユーザーID,ユーザー名が返ること' do
          get("/users/#{user.id}", headers:)

          json_response = response.parsed_body
          expect(json_response).to eq({
                                        'id' => user.id,
                                        'name' => user.name,
                                        'follower_count' => 0,
                                        'following_count' => 0
                                      })
        end
      end
    end

    context 'ユーザーが存在しない場合' do
      it '404が返ること' do
        get('/users/1', headers:)

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET /users' do
    let!(:user) { create(:user) }

    it '200が返ること' do
      get('/users', headers:)

      expect(response).to have_http_status(:ok)

      json_response = response.parsed_body
      expect(json_response.first).to eq(
        {
          'id' => authorized_user.id,
          'name' => authorized_user.name,
          'follower_count' => 0,
          'following_count' => 0
        }
      )
      expect(json_response.second).to eq(
        {
          'id' => user.id,
          'name' => user.name,
          'follower_count' => 0,
          'following_count' => 0
        }
      )
    end
  end

  describe 'POST /users' do
    subject { post '/users', params: params.to_json, headers: }

    let!(:headers) do
      { 'Content-Type' => 'application/json' }
    end

    context 'パラメータが正しい場合' do
      context 'プロフィール画像が存在する場合' do
        let!(:params) do
          file = fixture_file_upload(Rails.root.join('spec/fixtures/files/profile_image.jpg'), 'image/jpeg')
          {
            username: 'test_user',
            email: 'test@example.com',
            password: 'password',
            password_confirmation: 'password'
          }.merge(profile_image: file)
        end

        it '201が返ること' do
          subject
          expect(response).to have_http_status(:created)
        end
      end

      context 'プロフィール画像が存在しない場合' do
        let!(:params) do
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
    end

    context 'パラメータが不正な場合' do
      let!(:params) do
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
end
