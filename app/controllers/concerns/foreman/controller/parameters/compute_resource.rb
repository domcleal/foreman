module Foreman::Controller::Parameters::ComputeResource
  extend ActiveSupport::Concern
  include Foreman::Controller::Parameters::Taxonomix

  class_methods do
    def compute_resource_params_filter
      Foreman::ParameterFilter.new(::ComputeResource).tap do |filter|
        filter.permit :name, :provider, :description, :url, :set_console_password,
          :user, :password, :display_type

        # ec2
        filter.permit :access_key, :region

        # gce
        filter.permit :key_pair, :key_path, :project, :email, :zone

        # libvirt
        filter.permit :display_type, :uuid

        # openstack
        filter.permit :key_pair, :tenant, :allow_external_network

        # ovirt
        filter.permit :datacenter, :ovirt_quota, :public_key, :uuid

        # rackspace
        filter.permit :region

        # vmware
        filter.permit :pubkey_hash, :datacenter, :uuid, :server

        add_taxonomix_params_filter(filter)
      end
    end
  end

  def compute_resource_params
    self.class.compute_resource_params_filter.filter_params(params, parameter_filter_context)
  end
end
