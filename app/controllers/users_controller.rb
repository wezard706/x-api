# frozen_string_literal: true

class UsersController < ApplicationController
  wrap_parameters :user, include: %i[email username password password_confirmation]

  def create
    user = User.new(user_params)

    if user.save
      head :created
    else
      render json: { errors: format_errors(user.errors) }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation).merge(name: params[:username])
  end

  def format_errors(errors)
    errors.full_messages.map do |message|
      {
        message:
      }
    end
  end
end
