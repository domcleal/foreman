module Foreman::Controller::Parameters::Parameter
  def parameter_params_filter(type)
    Foreman::ParameterFilter.new(type).tap do |filter|
      filter.permit_by_context :name, :hidden_value, :value, :nested, :reference_id, :nested => true
      filter.permit_by_context :id, :_destroy, :ui => false, :api => false, :nested => true
    end
  end

  def parameter_params(type)
    parameter_params_filter(type).filter_params(params, parameter_filter_context)
  end
end
