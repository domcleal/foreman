module Foreman::Controller::Parameters::VariableLookupKey
  extend ActiveSupport::Concern
  include Foreman::Controller::Parameters::LookupKey

  class_methods do
    def variable_lookup_key_params_filter(top_level_hash = nil)
      Foreman::ParameterFilter.new(::VariableLookupKey, :top_level_hash => top_level_hash).tap do |filter|
        filter.permit :puppetclass
        filter.permit_by_context :id, :_destroy, :ui => false, :api => false, :nested => true

        add_lookup_key_params_filter(filter)
      end
    end
  end

  def variable_lookup_key_params(top_level_hash = nil)
    self.class.variable_lookup_key_params_filter(top_level_hash).filter_params(params, parameter_filter_context)
  end
end
