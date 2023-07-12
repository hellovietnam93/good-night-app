# frozen_string_literal: true

RSpec.shared_examples "unauthorized request" do |request_method, api_path|
  context "no auth_token" do
    before do
      send(request_method, api_path, headers: default_headers)
    end

    it "return unauthorized", :show_in_doc, doc_title: "Missing AUTH_TOKEN request" do
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context "invalid auth_token" do
    before do
      send(request_method, api_path, headers: authorized_headers("INVALID_TOKEN"))
    end

    it "return unauthorized", :show_in_doc, doc_title: "Unauthorized request" do
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
