module Foreman::Controller::Parameters::LookupValue
  extend ActiveSupport::Concern

  class_methods do
    def lookup_value_params_filter
      Foreman::ParameterFilter.new(::LookupValue).tap do |filter|
        filter.permit_by_context :match, :value, :lookup_key_id, :host_or_hostgroup,
          :use_puppet_default, :lookup_key, :hidden_value, :nested => true
        filter.permit_by_context :id, :_destroy, :ui => false, :api => false, :nested => true
      end
    end
  end

  def lookup_value_params
    self.class.lookup_value_params_filter.filter_params(params, parameter_filter_context)
  end
end
