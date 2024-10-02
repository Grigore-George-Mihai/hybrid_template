# frozen_string_literal: true

module ApiAuthHelpers
  def current_user
    auth_header = request.headers["Authorization"]
    return nil unless auth_header&.start_with?("Bearer ")

    token = auth_header.split.last
    Warden::JWTAuth::UserDecoder.new.call(token, :user, nil)
  end

  def authenticate_user!
    error!("401 Unauthorized", 401) unless current_user
  end
end
