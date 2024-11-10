# frozen_string_literal: true

module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid do |e|
      render json: ErrorResponse.new([e.to_s]), status: :unprocessable_entity
    end
  end
end
