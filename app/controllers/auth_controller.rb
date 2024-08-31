# frozen_string_literal: true

class AuthController < ApplicationController

  def sign_up
    user = User.new(sign_up_params)

    if user.save
      head :created
    else
      head :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:auth).permit(:name, :email, :password, :password_confirmation)
  end
end
