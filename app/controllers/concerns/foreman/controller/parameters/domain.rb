module Foreman::Controller::Parameters::Domain
  include Foreman::Controller::Parameters::DomainParameter

  def domain_params_filter
    Foreman::ParameterFilters.new(::Domain).tap do |filter|
      filter.permit(:name, :fullname, :dns_id, {:domain_parameters_attributes => [domain_parameter_params_filter]}, {}) # FIXME: opts parameter!
    end
  end

  def domain_params
    domain_params_filter.filter_params(params, parameter_filter_context)
  end
end
