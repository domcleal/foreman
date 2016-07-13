module Foreman::Controller::Parameters::Hostgroup
  extend ActiveSupport::Concern
  include Foreman::Controller::Parameters::HostCommon
  include Foreman::Controller::Parameters::NestedAncestryCommon
  include Foreman::Controller::Parameters::Parameter
  include Foreman::Controller::Parameters::Taxonomix

  class_methods do
    def hostgroup_params_filter
      Foreman::ParameterFilter.new(::Hostgroup).tap do |filter|
        filter.permit :name, :vm_defaults, :title, :root_pass,
          :arch, :arch_id, :arch_name,
          :architecture_id, :architecture_name,
          :domain_id, :domain_name,
          :environment_id, :environment_name,
          :medium_id, :medium_name,
          :subnet_id, :subnet_name,
          :subnet6_id, :subnet6_name,
          :realm_id, :realm_name,
          :operatingsystem_id, :operatingsystem_name,
          :os, :os_id, :os_name,
          :ptable_id, :ptable_name,
          :puppet_ca_proxy_id, :puppet_ca_proxy_name,
          :puppet_proxy_id, :puppet_proxy_name,
          :config_group_names => [], :config_group_ids => [],
          :puppetclass_ids => [], :puppetclass_names => [],
          :group_parameters_attributes => [parameter_params_filter(::GroupParameter)]

        add_host_common_params_filter(filter)
        add_nested_ancestry_common_params_filter(filter)
        add_taxonomix_params_filter(filter)
      end
    end
  end

  def hostgroup_params
    self.class.hostgroup_params_filter.filter_params(params, parameter_filter_context)
  end
end