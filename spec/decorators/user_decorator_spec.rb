# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserDecorator, type: :decorator do
  describe "#full_name" do
    let(:user) { build(:user, first_name: "John", last_name: "Doe") }
    let(:decorated_user) { user.decorate }

    it "returns the full name when both first and last name are present" do
      expect(decorated_user.full_name).to eq("John Doe")
    end
  end
end
