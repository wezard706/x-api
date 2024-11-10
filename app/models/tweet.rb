# frozen_string_literal: true

# == Schema Information
#
# Table name: tweets
#
#  id         :bigint           not null, primary key
#  content    :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_tweets_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Tweet < ApplicationRecord
  belongs_to :user

  validates :content, presence: true
  validate :valid_content_size?

  private

  def valid_content_size?
    errors.add(:base, 'ツイート可能な文字数を超えています。ツイートは140文字以内に収めてください') if content_size > 140
  end

  def content_size
    length = 0
    replaced_content = content.gsub(%r{https?://[^\s]+}) do |_|
      length += 22
      ''
    end

    replaced_content = replaced_content.gsub(/\r?\n/, '')

    replaced_content.each_char do |char|
      length += char.bytesize > 1 ? 2 : 1
    end

    length
  end
end
