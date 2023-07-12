# frozen_string_literal: true

module RequestSpecHelper
  def json
    JSON.parse(response.body)
  end

  def default_headers
    { CONTENT_TYPE: "application/json" }
  end

  def authorized_headers auth_token
    default_headers.merge(X_AUTH_TOKEN: auth_token)
  end

  def stub_current_user user
    allow_any_instance_of(Api::V1::BaseController).to receive(:current_user).and_return(user)
  end
end
