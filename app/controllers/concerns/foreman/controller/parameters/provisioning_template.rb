module Foreman::Controller::Parameters::ProvisioningTemplate
  extend ActiveSupport::Concern
  include Foreman::Controller::Parameters::Taxonomix
  include Foreman::Controller::Parameters::Template
  include Foreman::Controller::Parameters::TemplateCombination

  class_methods do
    def provisioning_template_params_filter(top_level_hash = nil)
      Foreman::ParameterFilter.new(::ProvisioningTemplate, :top_level_hash => top_level_hash).tap do |filter|
        filter.permit :template_combinations_attributes => [template_combination_params_filter],
          :operatingsystems => [], :operatingsystem_ids => [], :operatingsystem_names => []
        add_taxonomix_params_filter(filter)
        add_template_params_filter(filter)
      end
    end
  end

  def provisioning_template_params(top_level_hash = nil)
    self.class.provisioning_template_params_filter(top_level_hash).filter_params(params, parameter_filter_context)
  end
end
