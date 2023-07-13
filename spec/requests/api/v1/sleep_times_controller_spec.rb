# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::SleepTimesController, type: :request do
  let(:user) { create :user }
  let!(:user_token) { create :user_token, user: }
  let(:current_time) { Time.current }
  let(:sleep_time) { current_time.iso8601 }
  let(:wake_up_time) { (current_time + 2.hours).iso8601 }

  describe "GET /api/v1/sleep_times" do
    context "when has auth_token" do
      let(:user_id) { nil }
      let!(:sleep_time_record) { create :sleep_time, user: }

      context "when user_id is not current user" do
        context " when user_id is existed" do
          let(:user_id) { "NOT_FOUND" }
          before do
            get "/api/v1/sleep_times?user_id=#{user_id}", headers: authorized_headers(user_token.token)
          end

          it "raise error user not found", :show_in_doc, doc_title: "raise error user not found" do
            expect(response).to have_http_status(:not_found)
          end
        end

        context " when user_id is existed" do
          let(:user_2) { create :user }
          let(:user_id) { user_2.id }
          let!(:sleep_time_record_2) { create :sleep_time, user: user_2 }
          before do
            get "/api/v1/sleep_times?user_id=#{user_id}", headers: authorized_headers(user_token.token)
          end

          it "return list sleep times of user request", :show_in_doc,
             doc_title: "return list sleep times of user request" do
            expect(response).to have_http_status(:ok)
            expect(json["data"].count).to eq 1
            expect(json["data"].first["id"].to_i).to eq sleep_time_record_2.id
          end
        end
      end

      context "when user_id is blank" do
        before do
          get "/api/v1/sleep_times?user_id=#{user_id}", headers: authorized_headers(user_token.token)
        end

        it "return list sleep times of current user", :show_in_doc,
           doc_title: "return list sleep times of current user" do
          expect(response).to have_http_status(:ok)
          expect(json["data"].count).to eq 1
          expect(json["data"].first["id"].to_i).to eq sleep_time_record.id
        end
      end
    end

    include_examples "unauthorized request", "get", "/api/v1/sleep_times"
  end

  describe "POST /api/v1/sleep_times" do
    let(:params) do
      {
        sleep_record: {
          sleep_time:,
          wake_up_time:
        }
      }.to_json
    end

    context "when has auth_token" do
      before do
        post "/api/v1/sleep_times", params:, headers: authorized_headers(user_token.token)
      end

      context "create sleep_time success" do
        it "create a sleep_time record success", :show_in_doc, doc_title: "create a sleep_time record" do
          expect(response).to have_http_status(:ok)
        end
      end

      context "missing params" do
        let(:params) do
          {
            sleep_time:,
            wake_up_time:
          }.to_json
        end

        it "raise error missing params", :show_in_doc, doc_title: "raise error missing params" do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context "invalid time" do
        let(:wake_up_time) { (current_time - 2.hours).iso8601 }

        it "return errors wit invalid time", :show_in_doc, doc_title: "return errors wit invalid time" do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    include_examples "unauthorized request", "post", "/api/v1/sleep_times"
  end

  describe "GET /api/v1/sleep_times/:id" do
    context "when has auth_token" do
      let!(:sleep_time_record) { create :sleep_time, user: }

      before do
        get "/api/v1/sleep_times/#{record_id}", headers: authorized_headers(user_token.token)
      end

      context "when id not found" do
        let(:record_id) { "NOT_FOUND" }

        it "raise not found error", :show_in_doc, doc_title: "raise not found error" do
          expect(response).to have_http_status(:not_found)
        end
      end

      context "when id existed" do
        let(:record_id) { sleep_time_record.id }

        it "return sleep time data", :show_in_doc, doc_title: "return sleep time data" do
          expect(response).to have_http_status(:ok)
        end
      end
    end

    include_examples "unauthorized request", "get", "/api/v1/sleep_times/1"
  end
end
