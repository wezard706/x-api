# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Internet.username }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    password_confirmation { password }

    trait(:with_profile_image) do
      after(:build) do |user|
        user.profile_image.attach(
          io: Rails.root.join('spec/fixtures/files/profile_image.jpg').open,
          filename: 'profile_image.jpg',
          content_type: 'image/jpeg'
        )
      end
    end
  end
end
