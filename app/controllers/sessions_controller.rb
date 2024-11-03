# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
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
end
