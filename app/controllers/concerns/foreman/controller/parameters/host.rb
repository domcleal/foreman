module Foreman::Controller::Parameters::Host
  include Foreman::Controller::Parameters::HostBase
  include Foreman::Controller::Parameters::HostCommon

  def host_params_filter
    Foreman::ParameterFilter.new(::Host::Managed, :top_level_hash => 'host').tap do |filter|
      filter.permit :build, :certname, :disk, :global_status,
        :installed_at, :last_report, :otp, :provision_method, :uuid,
        :compute_attributes, # FIXME, not going to be passed through
        :compute_profile_id, :compute_profile_name,
        :compute_resource, :compute_resource_id, :compute_resource_name,
        :owner, :owner_id, :owner_name, :owner_type

      add_host_base_params_filter(filter)
      add_host_common_params_filter(filter)
    end
  end

  def host_params
    host_params_filter.filter_params(params, parameter_filter_context)
  end
end
