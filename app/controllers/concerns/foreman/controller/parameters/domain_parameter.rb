module Foreman::Controller::Parameters::DomainParameter
  def domain_parameter_param_filter
    filters = Foreman::ParameterFilters.new(::DomainParameter)
    filters.permit(:name, :hidden_value, :value, :_destroy, :nested, :reference_id, :nested => true)
    filters
  end

  def domain_parameter_params
    domain_parameter_param_filter.filter_params(params, filter_controller_type)
  end
end
