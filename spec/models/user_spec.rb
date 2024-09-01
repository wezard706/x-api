require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    context 'nameが設定されていない場合' do
      it 'バリデーションエラーになること' do
        user = User.new(email: 'test@example.com',
                        password: 'password',
                        password_confirmation: 'password')

        expect(user.valid?).to be false
        expect(user.errors.full_messages).to include("Name can't be blank")
      end
    end

    context 'emailが設定されていない場合' do
      it 'バリデーションエラーになること' do
        user = User.new(name: 'test',
                        password: 'password',
                        password_confirmation: 'password')

        expect(user.valid?).to be false
        expect(user.errors.full_messages).to include("Email can't be blank")
      end
    end

    context '不正なemailが設定されている場合' do
      it 'バリデーションエラーになること' do
        user = User.new(name: 'test',
                        email: 'invalid email',
                        password: 'password',
                        password_confirmation: 'password')

        expect(user.valid?).to be false
        expect(user.errors.full_messages).to include("Email is invalid")
      end
    end

    context 'パスワードが設定されていない場合' do
      it 'バリデーションエラーになること' do
        user = User.new(name: 'test',
                        email: 'test@example.com')

        expect(user.valid?).to be false
        expect(user.errors.full_messages).to include("Password can't be blank")
      end
    end

    context '確認用のパスワードが設定されていない場合' do
      context 'パスワードが設定されている場合' do
        it 'バリデーションエラーになること' do
          user = User.new(name: 'test',
                          email: 'test@example.com',
                          password: 'password')

          expect(user.valid?).to be false
          expect(user.errors.full_messages).to include("Password confirmation can't be blank")
        end
      end

      context 'パスワードが設定されていない場合' do
        it 'バリデーションエラーにならないこと' do
          User.new(name: 'test',
                   email: 'test@example.com',
                   password: 'password',
                   password_confirmation: 'password').save!

          user = User.find_by(email: 'test@example.com')
          user.name = 'changed name'

          expect(user.valid?).to be true
        end
      end
    end

    context '確認用のパスワードがパスワードと一致しない場合' do
      it 'バリデーションエラーになること' do
        user = User.new(name: 'test',
                        email: 'test@example.com',
                        password: 'password',
                        password_confirmation: 'no match')

        expect(user.valid?).to be false
        expect(user.errors.full_messages).to include("Password confirmation doesn't match Password")
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
        user = User.authenticate_by(email:, password:)

        expect(user.email).to eq(email)
      end
    end

    context 'emailが一致しない場合' do
      it 'nilが返ること' do
        user = User.authenticate_by(email: 'no match', password:)

        expect(user).to be_nil
      end
    end

    context 'パスワードが一致しない場合' do
      it 'nilが返ること' do
        user = User.authenticate_by(email:, password: 'no match')

        expect(user).to be_nil
      end
    end
  end
end
