# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      include UsersControllerDoc

      def index
        render_jsonapi User.all
      end
    end
  end
end
