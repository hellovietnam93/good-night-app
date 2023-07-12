# frozen_string_literal: true

module Api
  module Error
    class RecordNotFound < BaseError
      attr_reader :error

      def initialize errors = {}
        @error = errors[:error]
        @id = error.model.underscore
        @message = I18n.t("errors.records.not_found", resource: id)
      end
    end

    class InvalidParamster < BaseError
      def initialize errors = {}
        @id = errors[:id]
        @message = I18n.t("errors.params.invalid", param: id)
      end
    end

    class MissingToken < BaseError
      def initialize
        @id = SettingErrors.authentication.missing_token
        @message = I18n.t("errors.authentication.missing_token")
      end
    end

    class AuthenticationFailed < BaseError
      def initialize
        @id = SettingErrors.authentication.authentication_failed
        @message = I18n.t("errors.authentication.authentication_failed")
      end
    end
  end
end
