module Foreman::Controller::Parameters::ExternalUsergroup
  extend ActiveSupport::Concern

  class_methods do
    def external_usergroup_params_filter
      Foreman::ParameterFilter.new(::ExternalUsergroup).tap do |filter|
        filter.permit :usergroup, :usergroup_id, :usergroup_name, :name, :auth_source_id,
          :auth_source_name
      end
    end
  end

  def external_usergroup_params
    self.class.external_usergroup_params_filter.filter_params(params, parameter_filter_context)
  end
end
