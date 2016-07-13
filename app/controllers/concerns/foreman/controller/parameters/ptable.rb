module Foreman::Controller::Parameters::Ptable
  extend ActiveSupport::Concern
  include Foreman::Controller::Parameters::Taxonomix
  include Foreman::Controller::Parameters::Template

  class_methods do
    def ptable_params_filter
      Foreman::ParameterFilter.new(::Ptable).tap do |filter|
        filter.permit :layout, :os_family, :audit_comment,
          :operatingsystem_ids => [], :operatingsystem_names => [],
          :host_ids => [], :host_names => [],
          :hostgroup_names => [], :hostgroup_ids => []
        add_taxonomix_params_filter(filter)
        add_template_params_filter(filter)
      end
    end
  end

  def ptable_params
    self.class.ptable_params_filter.filter_params(params, parameter_filter_context)
  end
end
