module Foreman::Controller::Parameters::Parameter
  def parameter_params_filter
    Foreman::ParameterFilter.new(::Parameter).tap do |filter|
      filter.permit_by_context :id, :name, :hidden_value, :value, :_destroy, :nested, :reference_id,
        :nested => true
    end
  end

  def parameter_params
    parameter_params_filter.filter_params(params, parameter_filter_context)
  end
end
