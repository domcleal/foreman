module Foreman::Controller::Parameters::Subnet
  extend ActiveSupport::Concern
  include Foreman::Controller::Parameters::Parameter
  include Foreman::Controller::Parameters::Taxonomix

  class_methods do
    def subnet_params_filter
      Foreman::ParameterFilter.new(::Subnet).tap do |filter|
        filter.permit :name, :type, :network, :mask, :gateway, :dns_primary, :dns_secondary, :ipam, :from,
          :to, :vlanid, :boot_mode, :dhcp_id, :dhcp, :tftp_id, :tftp, :dns_id, :dns, :cidr, :network_type,
          :domain_ids => [], :domain_names => [],
          :subnet_parameters_attributes => [parameter_params_filter(::SubnetParameter)]
        add_taxonomix_params_filter(filter)
      end
    end
  end

  def subnet_params
    self.class.subnet_params_filter.filter_params(params, parameter_filter_context)
  end
end
