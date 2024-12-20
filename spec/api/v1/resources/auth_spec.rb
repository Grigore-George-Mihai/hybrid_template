# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Auth API", type: :request do
  let(:valid_user) { create(:user, password: "Password123!", password_confirmation: "Password123!") }
  let(:valid_attributes) do
    {
      first_name: "John",
      last_name: "Doe",
      email: "johndoe@example.com",
      password: "Password123!",
      password_confirmation: "Password123!"
    }
  end

  describe "POST /api/v1/auth/login" do
    it "logs in and returns a JWT token" do
      post "/api/v1/auth/login", params: { email: valid_user.email, password: "Password123!" }
      expect(response).to have_http_status(:created)
      expect(response_body[:auth]).to include(:token)
    end
  end

  describe "POST /api/v1/auth/register" do
    it "registers a new user and returns a JWT token" do
      post "/api/v1/auth/register", params: valid_attributes
      expect(response).to have_http_status(:created)
      expect(response_body[:auth]).to include(:token)
    end
  end

  describe "DELETE /api/v1/auth/logout" do
    it "logs out the user and returns a 204 status" do
      token = sign_in(valid_user)

      delete "/api/v1/auth/logout", headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:no_content)
    end

    it "returns 401 if no token is provided" do
      delete "/api/v1/auth/logout"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
