# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Followings' do
  include_context 'header'

  describe 'GET /users/:id/followings' do
    let!(:user) { create(:user) }
    let!(:followed) { create(:user) }
    let!(:follow) { create(:follow, follower: user, followed:) }

    it '200が返ること' do
      get("/users/#{user.id}/followings", headers:)

      expect(response).to have_http_status(:ok)
      json_response = response.parsed_body
      expect(json_response).to eq([{
                                    'id' => followed.id,
                                    'name' => followed.name
                                  }])
    end
  end
end
