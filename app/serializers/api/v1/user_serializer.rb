# frozen_string_literal: true

module Api
  module V1
    class UserSerializer < BaseSerializer
      attributes :id, :name, :email
    end
  end
end
