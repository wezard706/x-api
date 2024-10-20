# frozen_string_literal: true

require 'jwt'

module Jwt
  EXPIRED_SECONDS = 4 * 3600

  SECRET = Rails.application.credentials.secret_key_base

  ALGORITHM = 'HS256'

  def self.encode(email)
    payload = {
      email:,
      exp: Time.current.to_i + EXPIRED_SECONDS
    }
    JWT.encode payload, SECRET, ALGORITHM
  end

  def self.decode(jwt)
    JWT.decode jwt, SECRET, true, { algorithm: ALGORITHM }
  end
end
