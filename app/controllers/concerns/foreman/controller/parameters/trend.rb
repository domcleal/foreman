module Foreman::Controller::Parameters::Trend
  extend ActiveSupport::Concern

  class_methods do
    def trend_params_filter(top_level_hash = nil)
      Foreman::ParameterFilter.new(::Trend, :top_level_hash => top_level_hash).tap do |filter|
        filter.permit :name, :type,
          :fact_value, :fact_name,
          :trendable_type, :trendable_id
      end
    end
  end

  def trend_params(top_level_hash = nil)
    self.class.trend_params_filter(top_level_hash).filter_params(params, parameter_filter_context)
  end
end
