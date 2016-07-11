module Foreman::Controller::Parameters::ComputeAttribute
  include Foreman::Controller::Parameters::KeepParam

  def compute_attribute_params_filter
    Foreman::ParameterFilter.new(::ComputeAttribute).tap do |filter|
      filter.permit :compute_profile_id, :compute_resource_id
    end
  end

  def compute_attribute_params
    keep_param(params, :compute_attribute, :vm_attrs) do
      compute_attribute_params_filter.filter_params(params, parameter_filter_context)
    end
  end
end
