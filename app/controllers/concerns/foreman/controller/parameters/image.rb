module Foreman::Controller::Parameters::Image
  extend ActiveSupport::Concern

  class_methods do
    def image_params_filter
      Foreman::ParameterFilter.new(::Image).tap do |filter|
        filter.permit :name, :compute_resource_id, :compute_resource_name, :operatingsystem_id,
          :operatingsystem_name, :architecture_id, :architecture_name, :username, :password, :uuid,
          :user_data, :iam_role
      end
    end
  end

  def image_params
    self.class.image_params_filter.filter_params(params, parameter_filter_context)
  end
end
