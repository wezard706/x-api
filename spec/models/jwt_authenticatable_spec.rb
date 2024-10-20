# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JwtAuthenticatable do
  let!(:included_class) do
    Class.new do
      include JwtAuthenticatable
      attr_accessor :request

      def initialize
        # rubocop:disable Style/OpenStructUse
        @request = OpenStruct.new(headers: {})
        # rubocop:enable Style/OpenStructUse
      end
    end
  end
  let!(:instance) { included_class.new }

  describe '#authorize' do
    context '正しいJWTの場合' do
      let!(:user) { create(:user) }
      let!(:jwt) { Jwt.encode(user.email) }

      before do
        instance.request.headers['Authorization'] = "Bearer #{jwt}"
      end

      it '@current_user がセットされること' do
        instance.authorize!

        expect(instance.instance_variable_get(:@current_user)).to eq(user)
      end
    end

    context '不正なJWTの場合' do
      let!(:user) { create(:user) }
      let!(:jwt) { 'invalid jwt' }

      before do
        instance.request.headers['Authorization'] = "Bearer #{jwt}"
      end

      it '@current_user がセットされないこと' do
        instance.authorize!

        expect(instance.instance_variable_get(:@current_user)).to be_nil
      end
    end

    context 'ユーザーが存在しない場合' do
      let!(:jwt) { Jwt.encode(Faker::Internet.email) }

      before do
        instance.request.headers['Authorization'] = "Bearer #{jwt}"
      end

      it '@current_user がセットされないこと' do
        instance.authorize!

        expect(instance.instance_variable_get(:@current_user)).to be_nil
      end
    end

    context 'JWTが期限切れの場合' do
      let!(:user) { create(:user) }
      let!(:jwt) do
        stub_const('Jwt::EXPIRED_SECONDS', 0)
        Jwt.encode(user.email)
      end

      before do
        instance.request.headers['Authorization'] = "Bearer #{jwt}"
      end

      it '@current_user がセットされないこと' do
        instance.authorize!

        expect(instance.instance_variable_get(:@current_user)).to be_nil
      end
    end

    context 'Authorizationヘッダーが不正な場合' do
      let!(:user) { create(:user) }
      let!(:jwt) { Jwt.encode(user.email) }

      before do
        instance.request.headers['Authorization'] = jwt.to_s
      end

      it '@current_user がセットされないこと' do
        instance.authorize!

        expect(instance.instance_variable_get(:@current_user)).to be_nil
      end
    end

    context 'Authorizationヘッダーが存在しない場合' do
      it '@current_user がセットされないこと' do
        instance.authorize!

        expect(instance.instance_variable_get(:@current_user)).to be_nil
      end
    end
  end
end
