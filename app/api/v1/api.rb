# frozen_string_literal: true

module V1
  class Api < Grape::API
    version "v1", using: :path
    format :json
    prefix :api

    helpers do
      def current_user
        auth_header = request.headers["Authorization"]
        return nil unless auth_header&.start_with?("Bearer ")

        token = auth_header.split.last
        Warden::JWTAuth::UserDecoder.new.call(token, :user, nil)
      rescue StandardError
        nil
      end

      def authenticate_user!
        error!("401 Unauthorized", 401) unless current_user
      end
    end

    # Mount endpoints - Used by generator do not delete
    mount V1::Resources::Auth
  end
end
