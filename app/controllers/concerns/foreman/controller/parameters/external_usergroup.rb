module Foreman::Controller::Parameters::ExternalUsergroup
  def external_usergroup_params_filter
    Foreman::ParameterFilter.new(::ExternalUsergroup).tap do |filter|
      filter.permit :usergroup, :usergroup_id, :usergroup_name, :name, :auth_source_id,
        :auth_source_name
    end
  end

  def external_usergroup_params
    external_usergroup_params_filter.filter_params(params, parameter_filter_context)
  end
end
