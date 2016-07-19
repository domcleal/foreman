module Api
  module CompatibilityChecker
    extend ActiveSupport::Concern

    # removes unsupported "nested" flag from "host_parameters_attributes" (both Array and Hash formats supported)
    def check_create_host_nested
      if params[:host] && params[:host][:host_parameters_attributes]
        if params[:host][:host_parameters_attributes].is_a?(Array)
          params[:host][:host_parameters_attributes].each do |attribute|
            Foreman::Deprecation.api_deprecation_warning("Field host_parameters_attributes.nested ignored") unless attribute.delete(:nested).nil?
          end
        else
          params[:host][:host_parameters_attributes].each do |_, attribute|
            Foreman::Deprecation.api_deprecation_warning("Field host_parameters_attributes.nested ignored") unless attribute.delete(:nested).nil?
          end
        end
      end
    end
  end
end
