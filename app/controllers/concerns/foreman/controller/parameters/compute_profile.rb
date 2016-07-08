module Foreman::Controller::Parameters::ComputeProfile
  def compute_profile_params_filter
    Foreman::ParameterFilter.new(::ComputeProfile).tap do |filter|
      filter.permit :name
    end
  end

  def compute_profile_params
    compute_profile_params_filter.filter_params(params, parameter_filter_context)
  end
end
