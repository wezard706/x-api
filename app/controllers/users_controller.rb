# frozen_string_literal: true

class UsersController < AuthenticatedController
  skip_before_action :require_current_user!, only: [:create]

  def index
    users = User.order(:id)

    render json: users_response(users)
  end

  def show
    user = User.find(params[:id])

    render json: user_response(user)
  end

  def create
    user = User.new(user_params)

    if user.save
      head :created
    else
      render json: error_response(user.errors), status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation).merge(name: params[:username])
  end

  def users_response(users)
    users.map do |user|
      user_response(user)
    end
  end

  def user_response(user)
    {
      id: user.id,
      name: user.name
    }
  end

  def error_response(errors)
    formatted_errors = errors.full_messages.map do |message|
      {
        message:
      }
    end
    { errors: formatted_errors }
  end
end
