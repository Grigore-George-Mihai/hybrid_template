# frozen_string_literal: true

module V1
  module Resources
    class Auth < Grape::API
      resource :auth do
        desc "Login and get JWT token"
        params do
          requires :email, type: String, desc: "User email"
          requires :password, type: String, desc: "User password"
        end
        post :login do
          user = User.find_by(email: params[:email])

          if user&.valid_password?(params[:password])
            # Authenticate user and issue JWT token, without creating a session
            env["warden"].set_user(user, store: false)
            token = request.env["warden-jwt_auth.token"]

            error!("Token generation failed", 500) unless token

            present :auth, { token:, user: }, with: V1::Entities::AuthEntity
          else
            error!("Unauthorized", 401)
          end
        end

        desc "Register a new user"
        params do
          requires :first_name, type: String, desc: "User First name"
          requires :last_name, type: String, desc: "User Last name"
          requires :email, type: String, desc: "User email"
          requires :password, type: String, desc: "User Password"
          requires :password_confirmation, type: String, desc: "User Password confirmation"
        end
        post :register do
          user = User.new(
            email: params[:email],
            password: params[:password],
            password_confirmation: params[:password_confirmation],
            first_name: params[:first_name],
            last_name: params[:last_name]
          )

          if user.save
            env["warden"].set_user(user, store: false)
            token = request.env["warden-jwt_auth.token"]
            present :auth, { token:, user: }, with: V1::Entities::AuthEntity
          else
            error!(user.errors.full_messages, 422)
          end
        end

        desc "Logout the user"
        delete :logout do
          env["warden"].logout
          status 204
        end
      end
    end
  end
end
