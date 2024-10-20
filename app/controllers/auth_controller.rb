# frozen_string_literal: true

class AuthController < ApplicationController
  skip_before_action :require_current_user!

  def sign_up
    user = User.new(sign_up_params)

    if user.save
      head :created
    else
      render json: { errors: format_errors(user.errors) }, status: :unprocessable_entity
    end
  end

  def sign_in
    user = User.authenticate_by(email: params[:email], password: params[:password])

    if user.present?
      render json: {
        user_id: user.id,
        user_name: user.name,
        token: Jwt.encode(params[:email])
      }
    else
      head :unauthorized
    end
  end

  private

  def sign_up_params
    params.require(:auth).permit(:email, :password, :password_confirmation).merge(name: params[:username])
  end

  def format_errors(errors)
    errors.full_messages.map do |message|
      {
        message:
      }
    end
  end
end
