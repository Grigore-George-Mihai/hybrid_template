require "sidekiq/web"
require "sidekiq-scheduler/web"

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

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
