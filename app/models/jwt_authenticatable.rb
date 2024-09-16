# frozen_string_literal: true

module JwtAuthenticatable
  def authorized_user(jwt:)
    decoded_jwt = Jwt.decode(jwt:)
    User.find_by(email: decoded_jwt.first['email'])
  rescue JWT::ExpiredSignature
    Rails.logger.info('signature has been expired.')
    nil
  rescue JWT::VerificationError => e
    Rails.logger.warn("invalid verification. error_message: #{e.message}")
    nil
  end
end
