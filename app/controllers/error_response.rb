# frozen_string_literal: true

class ErrorResponse
  Error = Data.define(:message)

  def initialize(messages)
    @errors = messages.map do |message|
      Error.new(message:)
    end
  end

  def to_json(_options)
    {
      errors: @errors.map(&:to_h)
    }.to_json
  end
end
