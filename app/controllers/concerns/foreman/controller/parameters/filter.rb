module Foreman::Controller::Parameters::Filter
  extend ActiveSupport::Concern
  include Foreman::Controller::Parameters::Taxonomix

  class_methods do
    def filter_params_filter
      Foreman::ParameterFilter.new(::Filter).tap do |filter|
        filter.permit :search, :unlimited, :resource_type, :role_id, :taxonomy_search,
          :permissions => [], :permission_ids => [], :permission_names => []
        add_taxonomix_params_filter(filter)
      end
    end
  end

  def filter_params
    self.class.filter_params_filter.filter_params(params, parameter_filter_context)
  end
end
