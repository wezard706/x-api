# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    user = User.find(params[:id])

    render json: {
      id: user.id,
      name: user.name
    }
  end
end
