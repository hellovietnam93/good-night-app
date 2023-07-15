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

      it "return users data", :show_in_doc, doc_title: "get all users data" do
        expect(response).to have_http_status(:ok)
      end
    end

    include_examples "unauthorized request", "get", "/api/v1/users"
  end

  describe "GET /api/v1/users/followers" do
    let(:user_2) { create :user }

    context "when has auth_token" do
      before do
        user_2.follow!(user)
        get "/api/v1/users/followers", headers: authorized_headers(user_token.token)
      end

      it "return all followers of current user", :show_in_doc, doc_title: "get all followers of current user" do
        expect(response).to have_http_status(:ok)
        expect(json["data"].count).to eq 1
        expect(json["data"][0]["id"]).to eq user_2.id.to_s
      end
    end

    include_examples "unauthorized request", "get", "/api/v1/users/followers"
  end

  describe "GET /api/v1/users/followees" do
    let(:user_2) { create :user }

    context "when has auth_token" do
      before do
        user.follow!(user_2)
        get "/api/v1/users/followees", headers: authorized_headers(user_token.token)
      end

      it "return all followees of current user", :show_in_doc, doc_title: "get all followees of current user" do
        expect(response).to have_http_status(:ok)
        expect(json["data"].count).to eq 1
        expect(json["data"][0]["id"]).to eq user_2.id.to_s
      end
    end

    include_examples "unauthorized request", "get", "/api/v1/users/followees"
  end

  describe "POST /api/v1/users/:id/follow" do
    let(:user_2) { create :user }
    let(:user_id) { user_2.id }

    context "when has auth_token" do
      context "follow action" do
        before do
          post "/api/v1/users/#{user_id}/follow", headers: authorized_headers(user_token.token)
        end

        context "follow themself" do
          let(:user_id) { user.id }

          it "raise error", :show_in_doc, doc_title: "cannot follow themself" do
            expect(response).to have_http_status(:bad_request)
          end
        end

        context "follow other user" do
          it "follow success", :show_in_doc, doc_title: "follow other user" do
            expect(response).to have_http_status(:ok)
            expect(user.follows?(user_2)).to eq true
          end
        end
      end

      context "cannot follow user 2 times" do
        before do
          user.follow!(user_2)
          post "/api/v1/users/#{user_id}/follow", headers: authorized_headers(user_token.token)
        end

        it "raise error", :show_in_doc, doc_title: "cannot follow user 2 times" do
          expect(response).to have_http_status(:bad_request)
        end
      end
    end

    include_examples "unauthorized request", "post", "/api/v1/users/ID/follow"
  end

  describe "POST /api/v1/users/:id/unfollow" do
    let(:user_2) { create :user }
    let(:user_id) { user_2.id }

    context "when has auth_token" do
      context "unfollow action" do
        before do
          user.follow!(user_2)
          post "/api/v1/users/#{user_id}/unfollow", headers: authorized_headers(user_token.token)
        end

        context "unfollow other user" do
          it "unfollow success", :show_in_doc, doc_title: "unfollow other user" do
            expect(response).to have_http_status(:ok)
            expect(user.follows?(user_2)).to eq false
          end
        end
      end

      context "cannot unfollow user if not followed" do
        before do
          post "/api/v1/users/#{user_id}/unfollow", headers: authorized_headers(user_token.token)
        end

        it "raise error", :show_in_doc, doc_title: "annot unfollow user if not followed" do
          expect(response).to have_http_status(:bad_request)
        end
      end
    end

    include_examples "unauthorized request", "post", "/api/v1/users/ID/unfollow"
  end
end
