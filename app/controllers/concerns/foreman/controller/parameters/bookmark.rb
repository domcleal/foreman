module Foreman::Controller::Parameters::Bookmark
  extend ActiveSupport::Concern

  class_methods do
    def bookmark_params_filter
      Foreman::ParameterFilter.new(::Bookmark).tap do |filter|
        filter.permit :name, :query, :public, :controller
      end
    end
  end

  def bookmark_params
    self.class.bookmark_params_filter.filter_params(params, parameter_filter_context)
  end
end
