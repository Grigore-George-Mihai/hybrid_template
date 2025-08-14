require "sidekiq/web"

Rails.application.routes.draw do
  mount ApiRoot => "/"

  ActiveAdmin.routes(self)
  devise_for :users

  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => "/sidekiq"
    mount PgHero::Engine => "/pghero"
  end

  mount GrapeSwaggerRails::Engine => "/swagger" if Rails.env.development?

  # Define root route
  root "home#index"

  # Health check route at /up for monitoring app status
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
