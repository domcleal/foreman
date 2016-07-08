module Foreman::Controller::Parameters::Domain
  include Foreman::Controller::Parameters::Parameter
  include Foreman::Controller::Parameters::Taxonomix

  def domain_params_filter
    Foreman::ParameterFilter.new(::Domain).tap do |filter|
      filter.permit :name, :fullname, :dns_id,
        :domain_parameters_attributes => [parameter_params_filter(DomainParameter)]
      add_taxonomix_params_filter(filter)
    end
  end

  def domain_params
    domain_params_filter.filter_params(params, parameter_filter_context)
  end
end
