module Foreman::Controller::Parameters::DomainParameter
  def domain_parameter_params_filter
    Foreman::ParameterFilter.new(::DomainParameter).tap do |filter|
      filter.permit_by_context(:id, :name, :hidden_value, :value, :_destroy, :nested, :reference_id, :nested => true)
    end
  end

  def domain_parameter_params
    domain_parameter_params_filter.filter_params(params, parameter_filter_context)
  end
end
