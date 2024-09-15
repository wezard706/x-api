# frozen_string_literal: true

class AuthController < ApplicationController
  def sign_up
    user = User.new(sign_up_params)

    if user.save
      head :created
    else
      render json: { errors: format_errors(user.errors) }, status: :unprocessable_entity
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
