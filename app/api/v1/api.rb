# frozen_string_literal: true

module V1
  class Api < Grape::API
    version "v1", using: :path
    format :json
    prefix :api

    helpers ApiAuthHelpers

    # Mount endpoints - Used by generator do not delete
    mount V1::Resources::Auth
  end
end
