module Foreman::Controller::Parameters::HostCommon
  extend ActiveSupport::Concern
  include Foreman::Controller::Parameters::Parameter

  class_methods do
    def add_host_common_params_filter(filter)
      filter.permit :compute_profile, :compute_profile_id, :compute_profile_name,
        :grub_pass, :image_id, :image_name, :image_file, :lookup_value_matcher,
        :lookup_values_attributes, :use_image
    end
  end
end