# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  subject(:user) { create(:user) }

  describe "validations" do
    %i[first_name last_name email].each do |attribute|
      it { is_expected.to validate_presence_of(attribute) }
    end
  end

  describe "Devise modules" do
    let(:devise_modules) do
      %i[
        database_authenticatable
        registerable
        recoverable
        rememberable
        validatable
        jwt_authenticatable
      ]
    end

    it "includes the required Devise modules" do
      expect(user.devise_modules).to include(*devise_modules)
    end
  end

  describe "JWT functionality" do
    let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }

    it "creates a valid JWT token for the user" do
      expect(token).not_to be_nil
    end

    it "decodes the JWT token and finds the correct user" do
      decoded_user = Warden::JWTAuth::UserDecoder.new.call(token, :user, nil)
      expect(decoded_user).to eq(user)
    end

    it "revokes a JWT token" do
      payload = Warden::JWTAuth::UserDecoder.new.call(token, :user, nil)
      expect(described_class).not_to be_jwt_revoked(payload, user)

      # Simulate token revocation
      described_class.revoke_jwt(payload, user)
      expect(described_class).to be_jwt_revoked(payload, user)
    end
  end
end
