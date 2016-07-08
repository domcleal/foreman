module Foreman::Controller::Parameters::Parameter
  def parameter_params_filter(type)
    Foreman::ParameterFilter.new(type).tap do |filter|
      filter.permit_by_context :id, :name, :hidden_value, :value, :_destroy, :nested, :reference_id,
        :nested => true
    end
  end

  def parameter_params(type)
    parameter_params_filter(type).filter_params(params, parameter_filter_context)
  end
end
