# frozen_string_literal: true

module Api
  module V1
    class BaseSerializer
      include JSONAPI::Serializer
    end
  end
end
