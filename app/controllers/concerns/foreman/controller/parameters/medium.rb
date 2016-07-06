module Foreman::Controller::Parameters::Medium
  extend ActiveSupport::Concern
  include Foreman::Controller::Parameters::Taxonomix

  class_methods do
    def medium_params_filter
      Foreman::ParameterFilter.new(::Medium).tap do |filter|
        filter.permit :name, :path, :media_path, :config_path, :image_path,
          :os_family, :operatingsystems => [], :operatingsystem_ids => [],
          :operatingsystem_names => []
        add_taxonomix_params_filter(filter)
      end
    end
  end

  def medium_params
    self.class.medium_params_filter.filter_params(params, parameter_filter_context)
  end
end
