module Foreman::Controller::Parameters::LookupKey
  extend ActiveSupport::Concern
  include Foreman::Controller::Parameters::LookupValue

  class_methods do
    def add_lookup_key_params_filter(filter)
      filter.permit_by_context :avoid_duplicates, :default_value, :description,
        :key, :key_type, :hidden_value,
        :merge_overrides, :merge_default,
        :override, :override_value_order,
        :path,
        :parameter_type,
        :puppetclass_id,
        :use_puppet_default,
        :validator_type, :validator_rule,
        :variable, :variable_type,
        :lookup_values_attributes => [lookup_value_params_filter],
        :lookup_values => [lookup_value_params_filter], :lookup_value_ids => [],
        :override_values => [lookup_value_params_filter], :override_value_ids => [],
        :nested => true
    end
  end
end
