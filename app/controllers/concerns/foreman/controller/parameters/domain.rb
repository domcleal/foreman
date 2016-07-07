module Foreman::Controller::Parameters::Domain
  include Foreman::Controller::Parameters::DomainParameter
  include Foreman::Controller::Parameters::Taxonomix

  def domain_params_filter
    Foreman::ParameterFilter.new(::Domain).tap do |filter|
      filter.permit(:name, :fullname, :dns_id, {:domain_parameters_attributes => [domain_parameter_params_filter]}, {}) # FIXME: opts parameter!
      add_taxonomix_params_filter(filter)
    end
  end

  def domain_params
    domain_params_filter.filter_params(params, parameter_filter_context)
  end
end
