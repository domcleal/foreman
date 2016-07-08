module Foreman::Controller::Parameters::Environment
  include Foreman::Controller::Parameters::Taxonomix

  def environment_params_filter
    Foreman::ParameterFilter.new(::Environment).tap do |filter|
      filter.permit :name
      add_taxonomix_params_filter(filter)
    end
  end

  def environment_params
    environment_params_filter.filter_params(params, parameter_filter_context)
  end
end
