module Foreman::Controller::Parameters::AuthSourceLdap
  def auth_source_ldap_params_filter
    Foreman::ParameterFilter.new(::AuthSourceLdap).tap do |filter|
      filter.permit :name, :onthefly_register, :account_password, :usergroup_sync,
        :base_dn, :groups_base, :ldap_filter,:attr_login, :attr_firstname, :attr_lastname,
        :attr_mail, :attr_photo, :host, :tls, :port, :server_type, :account
    end
  end

  def auth_source_ldap_params
    auth_source_ldap_params_filter.filter_params(params, parameter_filter_context)
  end
end
