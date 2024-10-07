# frozen_string_literal: true

module ApiAuthHelpers
  include Pagy::Backend

  def current_user
    auth_header = request.headers["Authorization"]
    return nil unless auth_header&.start_with?("Bearer ")

    token = auth_header.split.last
    Warden::JWTAuth::UserDecoder.new.call(token, :user, nil)
  end

  def authenticate_user!
    error!("401 Unauthorized", 401) unless current_user
  end

  def paginated_response(collection, entity)
    pagy, records = pagy(collection, page: params[:page], limit: params[:per_page])

    {
      collection.model_name.plural => entity.represent(records, root: false),
      pagy: pagy_metadata(pagy).slice(:count, :page, :limit, :pages, :prev_url, :next_url)
    }
  end
end
