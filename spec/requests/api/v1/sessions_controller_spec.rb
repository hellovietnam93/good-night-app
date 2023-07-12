# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::SessionsController, type: :request do
  let(:password) { Faker::Internet.password(min_length: 10, max_length: 20) }
  let!(:user) { create :user, password: }
  let(:email) { user.email }

  describe "POST /api/v1/sessions" do
    let(:params) do
      {
        user: {
          email:,
          password:
        }
      }.to_json
    end

    context "when request valid email and password" do
      before do
        post "/api/v1/sessions", params:, headers: default_headers
      end

      it "sign in user success", :show_in_doc, doc_title: "sign in user success" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "when request valid params expeted" do
      let(:params) do
        {
          email:,
          password:
        }.to_json
      end

      before do
        post "/api/v1/sessions", params:, headers: default_headers
      end

      it "sign in user failed", :show_in_doc, doc_title: "sign in user failed" do
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when request invalid email or password" do
      before do
        post "/api/v1/sessions", params:, headers: default_headers
      end

      context "invalid email" do
        let(:email) { "invalid@invalid.com" }

        it "sign in user failed", :show_in_doc, doc_title: "sign in user failed" do
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context "invalid password" do
        let(:params) do
          {
            user: {
              email:,
              password: "INVALID_PASSWORD"
            }
          }.to_json
        end

        it "sign in user failed", :show_in_doc, doc_title: "sign in user failed" do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end
