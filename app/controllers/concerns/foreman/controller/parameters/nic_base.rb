module Foreman::Controller::Parameters::NicBase
  def add_nic_base_params_filter(filter)
    filter.permit :attached_to, :bond_options, # FIXME: bond_opts is array/hash?
      :compute_attributes, :host_id, :host, :identifier, :ip, :ip6, :link, :mac,  # FIXME: compute_attributes won't mass-assign
      :managed, :mode, :name, :password, :primary, :provider, :provision, :type,
      :tag, :username, :virtual,
      :_destroy, # used for nested_attributes
      :attached_devices => []
  end
end
