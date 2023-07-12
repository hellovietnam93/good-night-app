# frozen_string_literal: true

module Api
  module RescueExceptions
    extend ActiveSupport::Concern

    included do # rubocop:disable Metrics/BlockLength
      rescue_from ActionController::ParameterMissing do |error|
        render_invalid_params_response error
      end

      rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
      rescue_from ActiveRecord::RecordNotFound, with: :render_resource_not_found_response

      rescue_from Api::Error::MissingToken, with: :missing_token_render_options
      rescue_from Api::Error::AuthenticationFailed, with: :authentication_failed_render_options

      ###############################
      ########## protected ##########
      ###############################

      protected

      def render_invalid_params_response error, status: :bad_request
        error = Api::Error::InvalidParamster.new id: error.param
        render json: error.to_hash, status:
      end

      def render_unprocessable_entity_response exception, status: :bad_request
        error = ActiveRecordValidation::Error.new record: exception.record
        render json: error.to_hash, status:
      end

      def render_resource_not_found_response exception, status: :not_found
        error = Api::Error::RecordNotFound.new error: exception
        render json: error.to_hash, status:
      end

      def missing_token_render_options exception
        render json: exception.to_hash, status: :unauthorized
      end

      def authentication_failed_render_options exception
        render json: exception.to_hash, status: :unauthorized
      end
    end
  end
end
