# frozen_string_literal: true

module RequestsHelper
  RSpec.shared_context 'header' do
    let!(:authorized_user) { create(:user) }
    let!(:headers) do
      jwt = Jwt.encode(authorized_user.email)
      {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{jwt}"
      }
    end
  end
end
