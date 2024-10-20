# frozen_string_literal: true

module JwtAuthenticatable
  def authorize!
    Rails.logger.info("authorization_header: #{authorization_header}")
    return if authorization_header.nil?

    Rails.logger.info("jwt: #{jwt}")
    decoded_jwt = Jwt.decode(jwt)
    Rails.logger.info("decoded_jwt: #{decoded_jwt}")
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
    Rails.logger.info("authorization_header size: #{authorization_header.size}")
    /\ABearer\s(?<result>\S+)\z/ =~ authorization_header
    result
  end
end
