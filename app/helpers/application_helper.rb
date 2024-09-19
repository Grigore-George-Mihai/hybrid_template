# frozen_string_literal: true

module ApplicationHelper
  def bootstrap_class_for(flash_type)
    {
      success: "success",
      error: "danger",
      alert: "warning",
      notice: "info"
    }[flash_type.to_sym] || flash_type.to_s
  end
end
