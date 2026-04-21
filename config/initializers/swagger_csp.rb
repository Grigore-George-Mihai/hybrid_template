# frozen_string_literal: true

# grape-swagger-rails serves the Swagger UI with inline scripts/styles and
# pulls fonts from http://fonts.googleapis.com, all of which our global CSP
# blocks. The engine is mounted in development only, so strip CSP response
# headers for its path via a tiny Rack middleware.
if Rails.env.development?
  swagger_csp_bypass = Class.new do
    def initialize(app) = @app = app

    def call(env)
      swagger = env["PATH_INFO"].to_s.start_with?("/swagger")
      status, headers, body = @app.call(env)
      if swagger && headers.respond_to?(:delete)
        headers.each_key.to_a.each do |k|
          headers.delete(k) if k.to_s.downcase.start_with?("content-security-policy")
        end
      end
      [status, headers, body]
    end
  end

  Rails.application.config.middleware.insert_before(
    ActionDispatch::ContentSecurityPolicy::Middleware,
    swagger_csp_bypass
  )
end
