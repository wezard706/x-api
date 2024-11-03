# frozen_string_literal: true

class AuthenticatedController < ApplicationController
  include JwtAuthenticatable

  before_action :authorize!
  before_action :require_current_user!

  def require_current_user!
    head :unauthorized unless current_user
  end
end
