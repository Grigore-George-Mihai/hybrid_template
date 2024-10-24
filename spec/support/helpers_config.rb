# frozen_string_literal: true

module HelpersConfig
  def sign_in(user)
    post "/api/v1/auth/login", params: { email: user.email, password: user.password }
    response_body[:auth][:token] # Extract the JWT token from the response
  end

  def authenticate_request(user)
    token = sign_in(user)
    { "Authorization" => "Bearer #{token}" }
  end

  def response_body
    JSON.parse(response.body).with_indifferent_access
  end

  def register_user(params)
    post("/api/v1/auth/register", params:)
    response_body
  end
end
