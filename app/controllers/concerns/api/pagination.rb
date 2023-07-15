# frozen_string_literal: true

module Api
  module Pagination
    extend ActiveSupport::Concern
    include Pagy::Backend

    ###############################
    ########## protected ##########
    ###############################

    protected
    included do
      def paginate relation
        options = { page:, items: items.to_i, outset: params[:outset].to_i, count: count(relation) }
        pagy_info, records =
          if relation.is_a? Array
            pagy_array relation, options
          else
            pagy relation, options
          end
        [ pagy_repsonse(pagy_info), records ]
      end
    end

    ###############################
    ############ private ##########
    ###############################

    private
    def pagy_repsonse pagy
      pagy.instance_values.except(Settings.pagy.instances.vars).merge(limit: items.to_i)
    end

    def page
      @page ||= params[:page].to_i <= 0 ? Settings.pagy.page_default : params[:page]
    end

    def items
      limit = params[:limit].to_i

      @items ||= limit <= 0 ? Settings.pagy.items_default : limit_items(limit)
    end

    def limit_items limit
      return Settings.pagy.items_max if limit >= Settings.pagy.items_max

      Settings.pagy.available_limit.bsearch { |x| x >= limit }
    end

    def count relation
      @count ||= relation.count
    end
  end
end
