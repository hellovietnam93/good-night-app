# frozen_string_literal: true

module Api
  module JsonRender
    extend ActiveSupport::Concern

    class DataSanitizer
      def initialize object, options, api_version
        @object = object
        @options = options
        @api_version = api_version
      end

      def sanitize
        sanitized_data
      end

      ###############################
      ############ private ##########
      ###############################

      private

      attr_reader :object, :options, :api_version

      def sanitized_data
        @sanitized_data ||= serializer.new object, opts
      end

      def klass_name
        @klass_name ||= (object.respond_to?(:klass) ? object.klass : object.class).name
      end

      def serializer
        @serializer ||= options[:serializer] || "Api::#{api_version}::#{klass_name}Serializer".constantize
      end

      def opts
        @opts ||= options.except(:success, :status, :meta)
      end
    end

    protected

    included do
      def render_jsonapi object, options = {}
        meta = options.fetch :meta, {}
        success = options.fetch :success, true
        data_serializer =
          if object.is_a? String
            { data: nil }
          else
            DataSanitizer.new(object, options, api_version).sanitize.serializable_hash
          end
        render json: data_serializer.merge(meta:, success:), status:
      end

      def render_error er, status: 422
        render json: { errors: er }, status:
      end
    end

    def api_version
      @api_version ||= request.path.split("/")[2].upcase
    end
  end
end
