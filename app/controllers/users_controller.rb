# frozen_string_literal: true

class UsersController < AuthenticatedController
  def index
    users = User.order(:id)

    render json: users_response(users)
  end

  def show
    user = User.find(params[:id])

    render json: user_response(user)
  end

  private

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
end
