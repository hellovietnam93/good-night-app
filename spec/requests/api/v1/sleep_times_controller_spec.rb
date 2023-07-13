# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::SleepTimesController, type: :request do
  let(:user) { create :user }
  let!(:user_token) { create :user_token, user: }
  let(:current_time) { Time.current }
  let(:sleep_time) { current_time.iso8601 }
  let(:wake_up_time) { (current_time + 2.hours).iso8601 }

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
end
