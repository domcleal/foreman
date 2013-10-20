module Api
  module V2
    class BaseController < Api::BaseController
      include Api::Version2

      resource_description do
        resource_id "v2_base" # to avoid conflicts with V1::BaseController
        api_version "v2"
      end

      before_filter :root_node_name, :only => :index
      before_render :get_metadata, :only => :index
      layout 'api/v2/layouts/index_layout', :only => :index

      def root_node_name
        @root_node_name = if Rabl.configuration.use_controller_name_as_json_root
                            controller_name.split('/').last
                          elsif params['root_name'].present?
                            params['root_name']
                          else
                            Rabl.configuration.json_root_default_name
                          end
      end

      def get_metadata
        @results ||= instance_variable_get("@#{controller_name}")
        #@total should be defined in individual controllers, but in case it's not.
        @total ||= @results.count
        if (@search = params[:search]).present?
          @subtotal = @results.count
        else
          @subtotal = @total
        end

        if params[:order].present? && (order_array = params[:order].split(' ')).any?
          @by = order_array[0]
          @order   = order_array[1]
          @order ||= 'ASC'
        end

        @per_page = params[:per_page].present? ? params[:per_page].to_i : Setting::General.entries_per_page
        @limit = if @per_page > @subtotal
                   @subtotal
                 else
                   @per_page
                 end

        if params[:page].present?
          @page = params[:page].to_i
          @offset = (@page - 1) * @limit
        else
          @page = 1
          @offset = 0
        end

        if @page * @per_page > @subtotal
          @limit = @subtotal - (@page-1) * @per_page
          @limit = 0 if @limit < 0
        end
      end

    end
  end
end
