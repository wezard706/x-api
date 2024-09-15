# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable RSpec/PendingWithoutReason
RSpec.describe JwtAuthenticatable, :pending do
  describe '.authorized_user' do
    context '正しいJWTの場合' do
      let!(:email) { Faker::Internet.email }
      let!(:jwt) { described_class.generate(email:) }

      before do
        create(:user, email:)
      end

      it '認証された User が返ること' do
        user = described_class.verify(jwt:)

        expect(user.email).to eq email
      end
    end

    context '不正なJWTの場合' do
      context '署名が不正な場合' do
        let!(:email) { Faker::Internet.email }
        let!(:jwt) { "#{described_class.generate(email:)}invalid" }

        before do
          create(:user, email:)
        end

        it 'false が返ること' do
          user = described_class.verify(jwt:)

          expect(user).to be false
        end
      end

      context '署名は正しいが、ユーザーが存在しない場合' do
        let!(:email) { Faker::Internet.email }
        let!(:jwt) { described_class.generate(email:) }

        it 'false が返ること' do
          user = described_class.verify(jwt:)

          expect(user).to be false
        end
      end

      context '署名が期限切れの場合' do
        let!(:email) { Faker::Internet.email }
        let!(:jwt) do
          stub_const('JwtAuthenticator::EXPIRED_SECONDS', 0)
          described_class.generate(email:)
        end

        it 'false が返ること' do
          user = described_class.verify(jwt:)

          expect(user).to be false
        end
      end
    end
  end
end
# rubocop:enable RSpec/PendingWithoutReason
