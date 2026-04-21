# frozen_string_literal: true

require "rails_helper"

RSpec.describe ErrorHandler do
  include Rack::Test::Methods

  let(:app) do
    Class.new(Grape::API) do
      include ErrorHandler

      format :json

      get "/not_found" do
        raise ActiveRecord::RecordNotFound
      end

      get "/invalid" do
        User.new.save!
      end

      params do
        requires :foo, type: String
      end
      get "/bad_request" do
        {}
      end

      get "/expired" do
        raise JWT::ExpiredSignature
      end

      get "/decode" do
        raise JWT::DecodeError
      end

      get "/revoked" do
        raise Warden::JWTAuth::Errors::RevokedToken
      end

      get "/boom" do
        raise StandardError, "sensitive internal detail"
      end
    end
  end

  def body
    JSON.parse(last_response.body).with_indifferent_access
  end

  it "returns 404 for ActiveRecord::RecordNotFound" do
    get "/not_found"

    expect(last_response.status).to eq(404)
    expect(body[:errors]).to include(status: "Not Found", code: 404)
  end

  it "returns 422 with the validation message for ActiveRecord::RecordInvalid" do
    get "/invalid"

    expect(last_response.status).to eq(422)
    expect(body[:errors]).to include(status: "Unprocessable Entity", code: 422)
    expect(body[:errors][:message]).to be_present
  end

  it "returns 400 for Grape validation errors" do
    get "/bad_request"

    expect(last_response.status).to eq(400)
    expect(body[:errors]).to include(status: "Bad Request", code: 400)
    expect(body[:errors][:message]).to be_present
  end

  it "returns 401 for JWT::ExpiredSignature" do
    get "/expired"

    expect(last_response.status).to eq(401)
    expect(body[:errors]).to include(status: "Unauthorized", code: 401, message: "Token has expired")
  end

  it "returns 401 for JWT::DecodeError" do
    get "/decode"

    expect(last_response.status).to eq(401)
    expect(body[:errors]).to include(status: "Unauthorized", message: "Invalid token")
  end

  it "returns 401 for revoked JWT tokens" do
    get "/revoked"

    expect(last_response.status).to eq(401)
    expect(body[:errors]).to include(status: "Unauthorized", message: "Token has been revoked")
  end

  describe "unexpected errors" do
    before { allow(Rails.logger).to receive(:error) }

    it "returns a generic 500 without leaking the exception message to the client" do
      get "/boom"

      expect(last_response.status).to eq(500)
      expect(body[:errors]).to include(status: "Internal Server Error", code: 500)
      expect(body[:errors][:message]).to be_nil
      expect(last_response.body).not_to include("sensitive internal detail")
    end

    it "logs the exception server-side" do
      get "/boom"

      expect(Rails.logger).to have_received(:error).with(/StandardError.*sensitive internal detail/)
    end
  end
end
