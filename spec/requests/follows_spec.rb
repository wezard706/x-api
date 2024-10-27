# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Follows' do
  describe 'POST /follows' do
    subject { post '/follows', params: params.to_json, headers: }

    let!(:authorized_user) { create(:user) }
    let!(:jwt) { Jwt.encode(authorized_user.email) }
    let!(:headers) do
      {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{jwt}"
      }
    end
    let!(:followed) { create(:user) }
    let!(:params) do
      { followed_id: followed.id }
    end

    it '201が返ること' do
      subject
      expect(response).to have_http_status(:created)
    end
  end
end
