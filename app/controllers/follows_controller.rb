# frozen_string_literal: true

class FollowsController < AuthenticatedController
  before_action :set_followed
  def create
    follow = Follow.new(follower: current_user, followed: @followed)

    if follow.save
      head :created
    else
      render json: ErrorResponse.new(follow.errors), status: :unprocessable_entity
    end
  end

  private

  def set_followed
    @followed = User.find(params[:followed_id])
  end
end
