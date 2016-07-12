module Foreman::Controller::Parameters::NicBase
  extend ActiveSupport::Concern

  class_methods do
    def add_nic_base_params_filter(filter)
      filter.permit_by_context :attached_to, :bond_options, # FIXME: bond_opts is array/hash?
        :compute_attributes, :host_id, :host, :identifier, :ip, :ip6, :link, :mac,
        :managed, :mode, :name, :password, :primary, :provider, :provision, :type,
        :tag, :username, :virtual, :attached_devices => [], :nested => true
      filter.permit_by_context :id, :_destroy, :ui => false, :api => false, :nested => true
    end
  end
end
