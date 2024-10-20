# frozen_string_literal: true

module JwtAuthenticatable
  def authorize!
    return if authorization_header.nil?

    decoded_jwt = Jwt.decode(jwt)
    @current_user = User.find_by(email: decoded_jwt.first['email'])
  rescue JWT::ExpiredSignature
    Rails.logger.info('signature has been expired.')
  rescue JWT::VerificationError => e
    Rails.logger.warn("invalid verification. error_message: #{e.message}")
  rescue JWT::DecodeError => e
    Rails.logger.warn("other decode error. error_message: #{e.message}")
  end

  private attr_reader :current_user

  private

  def authorization_header
    request.headers['Authorization']
  end

  def jwt
    /\ABearer\s(?<result>\S+)\z/ =~ authorization_header
    result
  end
end
