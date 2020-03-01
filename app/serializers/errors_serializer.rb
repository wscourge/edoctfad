# frozen_string_literal: true

class ErrorsSerializer
  def initialize(error)
    @errors = error.is_a?(String) ? [error] : error.map { |key, val| "#{key} #{val.join(', ')}" }
  end

  def serialize
    { errors: @errors.map! { |error| { title: error } } }
  end
end
