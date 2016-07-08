module Foreman::Controller::Parameters::NicInterface
  include Foreman::Controller::Parameters::NicBase

  def nic_interface_params_filter
    Foreman::ParameterFilter.new(::Nic::Interface).tap do |filter|
      filter.permit :name, :subnet_id, :subnet, :subnet6_id, :subnet6, :domain_id, :domain
      add_nic_base_params_filter(filter)
    end
  end

  def nic_interface_params
    nic_interface_params_filter.filter_params(params, parameter_filter_context)
  end
end
