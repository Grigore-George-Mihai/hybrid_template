# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#bootstrap_class_for" do
    {
      primary: "primary",
      secondary: "secondary",
      success: "success",
      error: "danger",
      alert: "warning",
      notice: "info",
      warning: "warning",
      danger: "danger",
      info: "info",
      unknown: "dark"
    }.each do |key, value|
      it "returns '#{key}' for :#{value}" do
        expect(helper.bootstrap_class_for(key)).to eq(value)
      end
    end
  end
end
