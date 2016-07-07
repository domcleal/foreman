module Foreman::Controller::Parameters::Domain
  def domain_params
    filters = Foreman::ParameterFilters.new(::Domain)
    filters.permit(:name, :fullname, :dns_id, :domain_parameters_attributes)
    filters.filter_params(params, filter_controller_type)
  end
end
