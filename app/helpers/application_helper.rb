# frozen_string_literal: true

module ApplicationHelper
  def bootstrap_class_for(flash_type)
    {
      primary: "primary",
      secondary: "secondary",
      success: "success",
      error: "danger",
      alert: "warning",
      notice: "info",
      warning: "warning",
      danger: "danger",
      info: "info"
    }.fetch(flash_type.to_sym, "dark")
  end
end
