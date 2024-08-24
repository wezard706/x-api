# frozen_string_literal: true

require 'rails_helper'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
end


RSpec.describe Api::HttpbinClient do
  context '正常系' do
    it '200', :vcr do
      res = described_class.new.get

      expect(res.status).to eq(200)
    end
  end
end
