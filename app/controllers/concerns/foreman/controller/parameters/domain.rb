module Foreman::Controller::Parameters::Domain
  include Foreman::Controller::Parameters::DomainParameter

  def domain_param_filter
    filters = Foreman::ParameterFilters.new(::Domain)
    filters.permit(:name, :fullname, :dns_id, {:domain_parameters_attributes => [domain_parameter_param_filter]}, {}) # FIXME: opts parameter!
    filters
  end

  def domain_params
    domain_param_filter.filter_params(params, filter_controller_type)
  end
end
