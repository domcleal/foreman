module Foreman::Controller::Parameters::UserMailNotification
  extend ActiveSupport::Concern

  class_methods do
    def user_mail_notification_params_filter
      Foreman::ParameterFilter.new(::UserMailNotification).tap do |filter|
        filter.permit_by_context :mail_notification_id, :user_id, :interval, :mail_query, :nested => true
        filter.permit_by_context :id, :_destroy, :ui => false, :api => false, :nested => true
      end
    end
  end

  def user_mail_notification_params
    self.class.user_mail_notification_params_filter.filter_params(params, parameter_filter_context)
  end
end
