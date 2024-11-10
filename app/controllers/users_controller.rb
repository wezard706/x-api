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
      render json: ErrorResponse.new(user.errors.full_messages), status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation, :profile_image).merge(name: params[:username])
  end

  def users_response(users)
    users.map do |user|
      user.as_json(only: %i[id name], methods: %i[following_count follower_count])
    end
  end

  def user_response(user)
    user.as_json(only: %i[id name], methods: %i[following_count follower_count profile_image_url]).compact
  end
end
