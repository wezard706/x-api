# frozen_string_literal: true

class FollowsController < ApplicationController
  before_action :set_target_user
  def create
    follow = Follow.new(source_user: current_user, target_user: @target_user)

    if follow.save
      head :created
    else
      render json: { errors: format_errors(follow.errors) }, status: :unprocessable_entity
    end
  end

  private

  def set_target_user
    @target_user = User.find(params[:target_user_id])
  end

  def format_errors(errors)
    errors.full_messages.map do |message|
      {
        message:
      }
    end
  end
end
