# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tweets' do
  include_context 'header'

  describe 'POST /tweets' do
    let!(:params) do
      { content: 'hello world' }
    end

    it '201が返ること' do
      post('/tweets', params: params.to_json, headers:)

      expect(response).to have_http_status(:created)
    end
  end
end
