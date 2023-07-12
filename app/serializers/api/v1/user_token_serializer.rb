# frozen_string_literal: true

module Api
  module V1
    class UserTokenSerializer < BaseSerializer
      attributes :id, :token

      belongs_to :user
    end
  end
end
