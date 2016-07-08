module Foreman::Controller::Parameters::ComputeAttribute
  def compute_attribute_params_filter
    Foreman::ParameterFilter.new(::ComputeAttribute).tap do |filter|
      filter.permit :compute_profile_id, :compute_resource_id, :vm_attrs # TODO: verify vm_attrs, array?
    end
  end

  def compute_attribute_params
    compute_attribute_params_filter.filter_params(params, parameter_filter_context)
  end
end
