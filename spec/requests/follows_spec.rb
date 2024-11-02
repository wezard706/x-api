# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Follows' do
  include_context 'header'

  describe 'POST /follows' do
    let!(:followed) { create(:user) }
    let!(:params) do
      { followed_id: followed.id }
    end

    it '201が返ること' do
      post('/follows', params: params.to_json, headers:)

      expect(response).to have_http_status(:created)
    end
  end
end
