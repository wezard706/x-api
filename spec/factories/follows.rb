# frozen_string_literal: true

FactoryBot.define do
  factory :follow do
    followed factory: %i[user]
    follower factory: %i[user]
  end
end
