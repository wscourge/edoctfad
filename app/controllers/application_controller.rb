# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :validate_accept_header
  # rubocop:disable Rails/LexicallyScopedActionFilter:
  before_action :validate_content_type_header
  before_action :validate_resource_identifier, only: %i[show update delete]
  # rubocop:enable Rails/LexicallyScopedActionFilter:

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::UnknownAttributeError, with: :render_bad_request
  rescue_from ActionController::ParameterMissing, with: :render_forbidden

  private

  def resource_identifier
    raise(NotImplementedError, "#{self.class} has not implemented method '#{__method__}'")
  end

  def render_created(data)
    render(json: data, status: :created)
  end

  def render_ok(data)
    render(json: data, status: :ok)
  end

  def render_invalid(errors)
    render(json: serialized_errors(errors.to_h), status: :unprocessable_entity)
  end

  def render_not_found(exception)
    render(json: serialized_errors(exception.message), status: :not_found)
  end

  def render_conflict(errors)
    render(json: serialized_errors(errors), status: :conflict)
  end

  def render_forbidden(exception)
    render(json: serialized_errors(exception.message), status: :forbidden)
  end

  def render_no_content
    render(json: {}, status: :no_content)
  end

  def render_bad_request(error = 'Invalid request')
    render(json: serialized_errors(error), status: :bad_request)
  end

  def render_missing_header(header)
    render(json: serialized_errors("Header #{header} is required"), status: :not_acceptable)
  end

  def validate_header(key:, value:)
    return true if request.headers[key] == value

    render_missing_header("#{key} #{value}")
  end

  def validate_accept_header
    validate_header(key: 'Accept', value: 'application/json')
  end

  def validate_content_type_header
    validate_header(key: 'Content-Type', value: 'application/json')
  end

  def validate_resource_identifier
    errors = ResourceIdentifierContract.new.call(resource_identifier).errors
    return true if errors.blank?

    render(json: serialized_errors(errors), status: :bad_request)
  end

  def serialized_errors(errors)
    ErrorsSerializer.new(errors).serialize
  end
end
