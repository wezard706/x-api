# frozen_string_literal: true

module Users
  class FollowingsController < ApplicationController
    before_action :set_user
    def index
      followings = @user.followings
      render json: followings.map { |following| { id: following.id, name: following.name } }
    end

    private

    def set_user
      @user = User.find(params[:user_id])
    end
  end
end
