module Foreman::Controller::Parameters::NicInterface
  extend ActiveSupport::Concern
  include Foreman::Controller::Parameters::KeepParam
  include Foreman::Controller::Parameters::NicBase

  class_methods do
    def nic_interface_params_filter
      Foreman::ParameterFilter.new(::Nic::Interface, :top_level_hash => 'nic').tap do |filter|
        filter.permit_by_context :name, :subnet_id, :subnet, :subnet6_id, :subnet6,
          :domain_id, :domain, :nested => true
        add_nic_base_params_filter(filter)
      end
    end
  end

  def nic_interface_params
    keep_param(params, 'nic', :compute_attributes) do
      self.class.nic_interface_params_filter.filter_params(params, parameter_filter_context)
    end
  end
end
