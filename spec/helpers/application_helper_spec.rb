# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#bootstrap_class_for" do
    it "maps Rails flash keys to Bootstrap contextual classes" do
      expect(helper.bootstrap_class_for(:notice)).to eq("info")
      expect(helper.bootstrap_class_for(:alert)).to eq("warning")
      expect(helper.bootstrap_class_for(:error)).to eq("danger")
    end

    it "passes custom flash types through unchanged" do
      expect(helper.bootstrap_class_for(:success)).to eq("success")
      expect(helper.bootstrap_class_for(:danger)).to eq("danger")
    end

    it "accepts string input" do
      expect(helper.bootstrap_class_for("notice")).to eq("info")
    end

    it "falls back to 'dark' for unknown types" do
      expect(helper.bootstrap_class_for(:mystery)).to eq("dark")
    end
  end
end
