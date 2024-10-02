# frozen_string_literal: true

module ErrorHandler
  extend ActiveSupport::Concern

  included do
    # ActiveRecord errors
    rescue_from ActiveRecord::RecordNotFound do |_exception|
      error!({ errors: { status: I18n.t("errors.not_found") } }, 404)
    end

    rescue_from ActiveRecord::RecordInvalid do |_exception|
      error!({ errors: { status: I18n.t("errors.unprocessable_entity"), code: 422 } }, 422)
    end

    # Grape Validation errors
    rescue_from Grape::Exceptions::ValidationErrors do |exception|
      error!({ errors: { status: I18n.t("errors.bad_request"), code: 400, message: exception.message } }, 400)
    end

    # JWT-specific errors
    rescue_from JWT::ExpiredSignature do |_e|
      error!({ errors: { status: "Unauthorized", message: "Token has expired" } }, 401)
    end

    rescue_from JWT::DecodeError do |_e|
      error!({ errors: { status: "Unauthorized", message: "Invalid token" } }, 401)
    end

    rescue_from JWT::VerificationError do |_e|
      error!({ errors: { status: "Unauthorized", message: "Signature verification failed" } }, 401)
    end

    # Catch-all for unexpected errors
    rescue_from :all do |e|
      error!({ errors: { status: "Internal Server Error", message: e.message } }, 500)
    end
  end
end
