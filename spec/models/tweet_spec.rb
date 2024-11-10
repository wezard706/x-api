# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tweet do
  describe 'バリデーションのテスト' do
    let!(:user) { create(:user) }

    context 'contentの文字数が140文字の場合' do
      let!(:content) { 'a' * 140 }

      it 'バリデーションが通ること' do
        tweet = described_class.new(content:, user:)

        expect(tweet.valid?).to be true
      end
    end

    context 'contentの文字数が141文字の場合' do
      let!(:content) { 'a' * 141 }

      it 'バリデーションエラーになること' do
        tweet = described_class.new(content:, user:)

        expect(tweet.valid?).to be false
      end
    end
  end

  describe '#content_size' do
    let!(:user) { create(:user) }

    context 'contentが半角文字の場合' do
      let!(:content) { 'a' }

      it '半角文字は1文字でカウントされること' do
        tweet = described_class.new(content:, user:)

        expect(tweet.send(:content_size)).to eq(1)
      end
    end

    context 'contentが全角文字の場合' do
      let!(:content) { 'あ' }

      it '全角文字は2文字でカウントされること' do
        tweet = described_class.new(content:, user:)

        expect(tweet.send(:content_size)).to eq(2)
      end
    end

    context 'contentに改行を含む場合' do
      let!(:content) { "1\n2\n3" }

      it '改行はカウントされないこと' do
        tweet = described_class.new(content:, user:)

        expect(tweet.send(:content_size)).to eq(3)
      end
    end

    context 'contentがURLの場合' do
      context 'httpの場合' do
        let!(:content) { "url: http://example.com\n123" }

        it 'URLは22文字でカウントされること' do
          tweet = described_class.new(content:, user:)

          expect(tweet.send(:content_size)).to eq(30)
        end
      end

      context 'httpsの場合' do
        let!(:content) { "url: https://example.com\n123" }

        it 'URLは22文字でカウントされること' do
          tweet = described_class.new(content:, user:)

          expect(tweet.send(:content_size)).to eq(30)
        end
      end
    end
  end
end
