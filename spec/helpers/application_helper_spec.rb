# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#bootstrap_class_for" do
    it "returns the correct Bootstrap class" do
      expect(helper.bootstrap_class_for(:success)).to eq("success")
      expect(helper.bootstrap_class_for(:error)).to eq("danger")
      expect(helper.bootstrap_class_for(:alert)).to eq("warning")
      expect(helper.bootstrap_class_for(:notice)).to eq("info")
      expect(helper.bootstrap_class_for(:unknown)).to eq("dark")
    end
  end
end
