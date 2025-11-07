# frozen_string_literal: true

module ApiAuthHelpers
  include Pagy::Method

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
    pagy_opts = { page: params[:page], limit: params[:per_page] }.compact
    pagy, records = pagy(collection, **pagy_opts)

    {
      collection.model_name.plural => entity.represent(records, root: false),
      pagy: {
        count: pagy.count,
        page: pagy.page,
        limit: pagy.limit,
        pages: pagy.pages,
        prev_url: pagy.page_url(:previous),
        next_url: pagy.page_url(:next)
      }
    }
  end
end
