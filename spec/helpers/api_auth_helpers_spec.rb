# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApiAuthHelpers do
  let(:test_class) do
    Class.new do
      include ApiAuthHelpers

      attr_accessor :request, :params

      # Grape's endpoint exposes `error!`; stubbed here so we can assert against it.
      def error!(*); end
    end
  end
  let(:instance) { test_class.new }
  let(:user) { create(:user) }

  def stub_authorization(value)
    headers = value ? { "Authorization" => value } : {}
    instance.request = instance_double(ActionDispatch::Request, headers: headers)
  end

  describe "#current_user" do
    it "returns nil when no Authorization header is present" do
      stub_authorization(nil)
      expect(instance.current_user).to be_nil
    end

    it "returns nil when the Authorization scheme is not Bearer" do
      stub_authorization("Basic dXNlcjpwYXNz")
      expect(instance.current_user).to be_nil
    end

    it "decodes a valid Bearer token to the user" do
      token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
      stub_authorization("Bearer #{token}")

      expect(instance.current_user).to eq(user)
    end
  end

  describe "#authenticate_user!" do
    before { allow(instance).to receive(:error!) }

    it "calls error! with 401 when current_user is nil" do
      allow(instance).to receive(:current_user).and_return(nil)

      instance.authenticate_user!

      expect(instance).to have_received(:error!).with("401 Unauthorized", 401)
    end

    it "does not call error! when current_user is present" do
      allow(instance).to receive(:current_user).and_return(user)

      instance.authenticate_user!

      expect(instance).not_to have_received(:error!)
    end
  end

  describe "#paginated_response" do
    before { create_list(:user, 3) }

    let(:pagy_stub) do
      # Pagy's accessors aren't detectable by instance_double, so a plain double is used here.
      pagy = double("Pagy", count: 3, page: 1, limit: 25, pages: 1) # rubocop:disable RSpec/VerifiedDoubles
      allow(pagy).to receive(:page_url).with(:previous).and_return(nil)
      allow(pagy).to receive(:page_url).with(:next).and_return("/api/v1/users?page=2")
      pagy
    end

    let(:expected_meta) do
      {
        count: 3, page: 1, limit: 25, pages: 1,
        prev_url: nil, next_url: "/api/v1/users?page=2"
      }
    end

    it "wraps the collection under the plural model name" do
      instance.params = {}
      allow(instance).to receive(:pagy).and_return([pagy_stub, User.all.to_a])

      result = instance.paginated_response(User.all, V1::Entities::UserEntity)

      expect(result["users"].size).to eq(3)
    end

    it "includes pagy metadata" do
      instance.params = {}
      allow(instance).to receive(:pagy).and_return([pagy_stub, User.all.to_a])

      result = instance.paginated_response(User.all, V1::Entities::UserEntity)

      expect(result[:pagy]).to eq(expected_meta)
    end

    it "forwards page and per_page params to pagy as page and limit" do
      instance.params = { page: "2", per_page: "10" }
      allow(instance).to receive(:pagy).and_return([pagy_stub, []])

      instance.paginated_response(User.all, V1::Entities::UserEntity)

      expect(instance).to have_received(:pagy).with(anything, page: "2", limit: "10")
    end

    it "omits nil pagination params" do
      instance.params = {}
      allow(instance).to receive(:pagy).and_return([pagy_stub, []])

      instance.paginated_response(User.all, V1::Entities::UserEntity)

      expect(instance).to have_received(:pagy).with(anything)
    end
  end
end
