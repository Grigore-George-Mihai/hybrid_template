# frozen_string_literal: true

module ErrorHandler
  extend ActiveSupport::Concern

  included do
    helpers do
      def render_api_error(status_code, status_text, message = nil)
        payload = { errors: { status: status_text, code: status_code } }
        payload[:errors][:message] = message if message
        error!(payload, status_code)
      end
    end

    # ActiveRecord errors
    rescue_from ActiveRecord::RecordNotFound do
      render_api_error(404, I18n.t("errors.not_found"))
    end

    rescue_from ActiveRecord::RecordInvalid do |exception|
      render_api_error(
        422,
        I18n.t("errors.unprocessable_entity"),
        exception.record.errors.full_messages.join(", ")
      )
    end

    # Grape validation errors
    rescue_from Grape::Exceptions::ValidationErrors do |exception|
      render_api_error(400, I18n.t("errors.bad_request"), exception.message)
    end

    # JWT / devise-jwt errors.
    # Note: Warden::JWTAuth::Errors::RevokedToken inherits from JWT::DecodeError,
    # so it must be declared BEFORE JWT::DecodeError for Grape's rescue_from to
    # match the more-specific handler first.
    rescue_from Warden::JWTAuth::Errors::RevokedToken do
      render_api_error(401, "Unauthorized", "Token has been revoked")
    end

    rescue_from JWT::ExpiredSignature do
      render_api_error(401, "Unauthorized", "Token has expired")
    end

    rescue_from JWT::DecodeError do
      render_api_error(401, "Unauthorized", "Invalid token")
    end

    # Catch-all for unexpected errors. Log full details server-side;
    # return a generic response so we don't leak internal state to clients.
    rescue_from :all do |exception|
      Rails.logger.error("[API] #{exception.class}: #{exception.message}")
      Rails.logger.error(exception.backtrace.first(10).join("\n")) if exception.backtrace
      Rollbar.error(exception) if defined?(Rollbar)
      render_api_error(500, "Internal Server Error")
    end
  end
end
