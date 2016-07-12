module Foreman::Controller::Parameters::PuppetclassLookupKey
  extend ActiveSupport::Concern
  include Foreman::Controller::Parameters::LookupKey

  class_methods do
    def puppetclass_lookup_key_params_filter(top_level_hash = nil)
      Foreman::ParameterFilter.new(::PuppetclassLookupKey, :top_level_hash => top_level_hash).tap do |filter|
        filter.permit :required, :environments => [], :environment_ids => [], :environment_names => [],
          :environment_classes => [], :environment_classes_ids => [], :environment_classes_names => [],
          :param_classes => [], :param_classes_ids => [], :param_classes_names => []
        add_lookup_key_params_filter(filter)
      end
    end
  end

  def puppetclass_lookup_key_params(top_level_hash = nil)
    self.class.puppetclass_lookup_key_params_filter(top_level_hash).filter_params(params, parameter_filter_context)
  end
end
