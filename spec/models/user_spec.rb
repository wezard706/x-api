# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe 'バリデーション' do
    context 'nameが設定されていない場合' do
      it 'バリデーションエラーになること' do
        user = described_class.new(email: 'test@example.com',
                                   password: 'password',
                                   password_confirmation: 'password')

        expect(user.valid?).to be false
        expect(user.errors.full_messages).to eq ['ユーザー名を入力してください']
      end
    end

    context 'emailが設定されていない場合' do
      it 'バリデーションエラーになること' do
        user = described_class.new(name: 'test',
                                   password: 'password',
                                   password_confirmation: 'password')

        expect(user.valid?).to be false
        expect(user.errors.full_messages).to eq(%w[メールアドレスは不正な値です メールアドレスを入力してください])
      end
    end

    context '不正なemailが設定されている場合' do
      it 'バリデーションエラーになること' do
        user = described_class.new(name: 'test',
                                   email: 'invalid email',
                                   password: 'password',
                                   password_confirmation: 'password')

        expect(user.valid?).to be false
        expect(user.errors.full_messages).to eq(['メールアドレスは不正な値です'])
      end
    end

    context 'パスワードが設定されていない場合' do
      it 'バリデーションエラーになること' do
        user = described_class.new(name: 'test',
                                   email: 'test@example.com')

        expect(user.valid?).to be false
        expect(user.errors.full_messages).to eq(['パスワードを入力してください'])
      end
    end

    context '確認用のパスワードが設定されていない場合' do
      context 'パスワードが設定されている場合' do
        it 'バリデーションエラーになること' do
          user = described_class.new(name: 'test',
                                     email: 'test@example.com',
                                     password: 'password')

          expect(user.valid?).to be false
          expect(user.errors.full_messages).to eq(['確認用のパスワードを入力してください'])
        end
      end

      context 'パスワードが設定されていない場合' do
        it 'バリデーションエラーにならないこと' do
          described_class.new(name: 'test',
                              email: 'test@example.com',
                              password: 'password',
                              password_confirmation: 'password').save!

          user = described_class.find_by(email: 'test@example.com')
          user.name = 'changed name'

          expect(user.valid?).to be true
        end
      end
    end

    context '確認用のパスワードがパスワードと一致しない場合' do
      it 'バリデーションエラーになること' do
        user = described_class.new(name: 'test',
                                   email: 'test@example.com',
                                   password: 'password',
                                   password_confirmation: 'no match')

        expect(user.valid?).to be false
        expect(user.errors.full_messages).to eq(['確認用のパスワードとパスワードの入力が一致しません'])
      end
    end
  end

  describe '.authenticate_by' do
    let!(:email) { 'test@example.com' }
    let!(:password) { 'password' }

    before do
      create(:user, email:, password:)
    end

    context 'パスワードが一致する場合' do
      it '認証に成功したUserのオブジェクトが返ること' do
        user = described_class.authenticate_by(email:, password:)

        expect(user.email).to eq(email)
      end
    end

    context 'emailが一致しない場合' do
      it 'nilが返ること' do
        user = described_class.authenticate_by(email: 'no match', password:)

        expect(user).to be_nil
      end
    end

    context 'パスワードが一致しない場合' do
      it 'nilが返ること' do
        user = described_class.authenticate_by(email:, password: 'no match')

        expect(user).to be_nil
      end
    end
  end
end
