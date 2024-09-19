# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Auth API", type: :request do
  let(:valid_user) { create(:user, password: "password123") }
  let(:valid_attributes) do
    {
      first_name: "John",
      last_name: "Doe",
      email: "johndoe@example.com",
      password: "password123",
      password_confirmation: "password123"
    }
  end

  describe "POST /api/v1/auth/login" do
    it "logs in and returns a JWT token" do
      post "/api/v1/auth/login", params: { email: valid_user.email, password: "password123" }
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
end
