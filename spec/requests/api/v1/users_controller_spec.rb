# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::UsersController, type: :request do
  let(:user) { create :user }
  let!(:user_token) { create :user_token, user: }

  describe "GET /api/v1/users" do
    context "when has auth_token" do
      before do
        get "/api/v1/users", headers: authorized_headers(user_token.token)
      end

      it "return data maps data", :show_in_doc, doc_title: "get all data maps" do
        expect(response).to have_http_status(:ok)
      end
    end

    include_examples "unauthorized request", "get", "/api/v1/users"
  end
end
