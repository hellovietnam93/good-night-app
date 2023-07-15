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

          context "when followed" do
            before do
              user.follow!(user_2)
              get "/api/v1/sleep_times?user_id=#{user_id}", headers: authorized_headers(user_token.token)
            end

            it "return list sleep times of user request", :show_in_doc,
               doc_title: "return list sleep times of user request" do
              expect(response).to have_http_status(:ok)
              expect(json["data"].count).to eq 1
              expect(json["data"].first["id"].to_i).to eq sleep_time_record_2.id
            end
          end

          context "when not followed" do
            before do
              get "/api/v1/sleep_times?user_id=#{user_id}", headers: authorized_headers(user_token.token)
            end

            it "return list sleep times of user request", :show_in_doc,
               doc_title: "return list sleep times of user request" do
              expect(response).to have_http_status(:ok)
              expect(json["data"].count).to eq 0
            end
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

  describe "GET /api/v1/sleep_times/followees" do
    context "when has auth_token" do
      let(:user_id) { nil }
      let!(:sleep_time_record) { create :sleep_time, user: }

      context "when current_user did no follow anyone" do
        before do
          get "/api/v1/sleep_times/followees", headers: authorized_headers(user_token.token)
        end
        it "return empty data", :show_in_doc, doc_title: "return empty data" do
          expect(response).to have_http_status(:ok)
          expect(json["data"].count).to eq 0
        end
      end

      context "when current_user followed someone" do
        let(:start_time) { nil }
        let(:end_time) { nil }
        let(:params) do
          {
            start_time:,
            end_time:
          }
        end
        let(:user_2) { create :user }
        let(:begining_of_last_week) { 1.week.ago.beginning_of_week }
        let!(:sleep_time_record_2) { create :sleep_time, user: user_2 }
        let!(:sleep_time_record_3) do
          create :sleep_time, user: user_2, sleep_time: (begining_of_last_week + 25.hours),
            wake_up_time: (begining_of_last_week + 29.hours)
        end
        let!(:sleep_time_record_4) do
          create :sleep_time, user: user_2, sleep_time: (begining_of_last_week + 30.hours),
            wake_up_time: (begining_of_last_week + 31.hours)
        end

        before do
          user.follow!(user_2)
          get "/api/v1/sleep_times/followees", params:, headers: authorized_headers(user_token.token)
        end

        context "when time range condition is empty" do
          it "return data of followees", :show_in_doc, doc_title: "return data of followees" do
            expect(response).to have_http_status(:ok)
            expect(json["data"].count).to eq 3
            expect(json["data"][0]["id"].to_i).to eq sleep_time_record_3.id
          end
        end

        context "when end time is blank" do
          context "when start time is invalid format" do
            let(:start_time) { 2.days.ago }

            it "raturn messsage invalid format for start time", :show_in_doc,
               doc_title: "raturn messsage invalid format for start time" do
              expect(response).to have_http_status(:bad_request)
              expect(json["errors"][0]["message"]).to eq I18n.t("errors.time_range.invalid", field: "start_time")
            end
          end

          context "when start time is valid format" do
            let(:start_time) { 2.days.ago.iso8601 }

            it "return data of followees", :show_in_doc, doc_title: "return data of followees" do
              expect(response).to have_http_status(:ok)
              expect(json["data"].count).to eq 1
              expect(json["data"][0]["id"].to_i).to eq sleep_time_record_2.id
            end
          end
        end

        context "when start time and last time is not blank" do
          let(:start_time) { begining_of_last_week.iso8601 }
          context "when end time is invalid format" do
            let(:end_time) { begining_of_last_week.end_of_week }

            it "raturn messsage invalid format for end time", :show_in_doc,
               doc_title: "raturn messsage invalid format for end time" do
              expect(response).to have_http_status(:bad_request)
              expect(json["errors"][0]["message"]).to eq I18n.t("errors.time_range.invalid", field: "end_time")
            end
          end

          context "when end time is valid format" do
            let(:end_time) { begining_of_last_week.end_of_week.iso8601 }

            it "return data of followees", :show_in_doc, doc_title: "return data of followees" do
              expect(response).to have_http_status(:ok)
              expect(json["data"].count).to eq 2
              expect(json["data"][0]["id"].to_i).to eq sleep_time_record_3.id
            end
          end
        end
      end
    end

    include_examples "unauthorized request", "get", "/api/v1/sleep_times/followees"
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
