# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#bootstrap_class_for" do
    it "returns the correct Bootstrap class for success" do
      expect(helper.bootstrap_class_for(:success)).to eq("success")
    end

    it "returns the correct Bootstrap class for error" do
      expect(helper.bootstrap_class_for(:error)).to eq("danger")
    end

    it "returns the correct Bootstrap class for alert" do
      expect(helper.bootstrap_class_for(:alert)).to eq("warning")
    end

    it "returns the correct Bootstrap class for notice" do
      expect(helper.bootstrap_class_for(:notice)).to eq("info")
    end

    it "returns the flash type as a string if it is not mapped" do
      expect(helper.bootstrap_class_for(:unknown)).to eq("unknown")
    end
  end
end
