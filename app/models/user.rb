# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string(255)      not null
#  name            :string(255)      not null
#  password_digest :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#  index_users_on_name   (name) UNIQUE
#
class User < ApplicationRecord
  has_many :active_relationships, class_name: 'Follow',
                                  foreign_key: 'follower_id', inverse_of: :user, dependent: :destroy
  has_many :followings, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: 'Follow',
                                   foreign_key: 'followed_id', inverse_of: :user, dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :tweets, dependent: :destroy

  has_one_attached :profile_image

  has_secure_password

  validates :name, presence: true, uniqueness: { case_insensitive: true }
  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            presence: true,
            uniqueness: { case_insensitive: true }
  validates :password_confirmation, presence: true, if: -> { password.present? }

  def profile_image_url
    Rails.application.routes.url_helpers.rails_blob_url(profile_image) if profile_image.attached?
  end

  def following_count
    followings.count
  end

  def follower_count
    followers.count
  end
end
