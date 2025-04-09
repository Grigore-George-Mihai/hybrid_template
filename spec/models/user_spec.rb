# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

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

  describe "Enums" do
    it "defines roles with correct values" do
      expect(described_class.roles).to eq("user" => 0, "admin" => 1)
    end
  end

  describe "#ransackable_attributes" do
    it "returns the correct ransackable attributes" do
      expect(described_class.ransackable_attributes).to match_array(%w[first_name last_name email role])
    end
  end

  describe "#password_required?" do
    context "when the user is a new record" do
      it "returns true" do
        new_user = build(:user)
        expect(new_user.password_required?).to be(true)
      end
    end

    context "when the password is present" do
      it "returns true" do
        user.password = "newpassword"
        expect(user.password_required?).to be(true)
      end
    end

    context "when the password confirmation is present" do
      it "returns true" do
        user.password_confirmation = "newpassword"
        expect(user.password_required?).to be(true)
      end
    end

    context "when password and confirmation are not present for an existing user" do
      it "returns false" do
        user.password = nil
        user.password_confirmation = nil
        expect(user.password_required?).to be(false)
      end
    end
  end

  describe "#full_name" do
    it "returns the first and last name joined by a space" do
      user = build(:user, first_name: "Ada", last_name: "Lovelace")
      expect(user.full_name).to eq("Ada Lovelace")
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
