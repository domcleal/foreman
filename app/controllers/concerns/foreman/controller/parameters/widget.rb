module Foreman::Controller::Parameters::Widget
  extend ActiveSupport::Concern

  class_methods do
    def widget_params_filter(top_level_hash = nil)
      Foreman::ParameterFilter.new(::Widget, :top_level_hash => top_level_hash).tap do |filter|
        filter.permit :col, :hide, :row, :sizex, :sizey
      end
    end
  end
end
