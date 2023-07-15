# frozen_string_literal: true

module Api
  module Helpers
    module Authentication
      extend ActiveSupport::Concern

      included do
        attr_reader :is_resource_set, :is_skip_authorize_permission
      end

      ###

      def skip_authorize_permission
        @is_skip_authorize_permission = true
      end

      ###

      def set_resource data, action: nil
        authorize! mapping_actions(action || params[:action]), data, message: "#{data.class}##{data.id}"
        @is_resource_set = true
        data
      end

      ###

      def set_resources data, action: nil
        @is_resource_set = true
        data.accessible_by(current_ability, mapping_actions(action || params[:action]))
      end

      ###

      def mapping_actions action
        { show: :read, index: :read }[action] || action.to_sym
      end

      # checking at https://msp-greg.github.io/rubocop/RuboCop/Cop/Style/ArgumentsForwarding.html
      # ArgumentsForwarding
      # # bad
      # def foo(*args, &block)
      #   bar(*args, &block)
      # end

      # # good
      # def foo(...)
      #   bar(...)
      # end

      def render(...)
        return super if is_skip_authorize_permission
        return super if _normalize_render(...)[:skip_authorize_permission]
        raise "Need to define [resource] data or call skip_authorize_permission" unless is_resource_set

        super
      end
    end
  end
end
