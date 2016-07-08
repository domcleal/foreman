module Foreman::Controller::Parameters::ConfigGroup
  def config_group_params_filter
    Foreman::ParameterFilter.new(::ConfigGroup).tap do |filter|
      filter.permit :name, :class_environments => [], :puppetclass_ids => [],
        :puppetclass_names => []
    end
  end

  def config_group_params
    config_group_params_filter.filter_params(params, parameter_filter_context)
  end
end
