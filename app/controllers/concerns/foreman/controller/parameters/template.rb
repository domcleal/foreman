module Foreman::Controller::Parameters::Template
  extend ActiveSupport::Concern

  class_methods do
    def add_template_params_filter(filter)
      filter.permit :name, :default, :template, :audit_comment, :snippet, :locked,
        :template_kind, :template_kind_name, :template_kind_id, :vendor
    end
  end
end
