module Api
  module V2
    class ComputeAttributesController < V2::BaseController
      include Foreman::Controller::Parameters::ComputeAttribute

      before_filter :find_resource, :only => :update

      def_param_group :compute_attribute do
        param :compute_attribute, Hash, :required => true, :action_aware => true do
          param :vm_attrs, Hash, :required => true
        end
      end

      api :POST, "/compute_resources/:compute_resource_id/compute_profiles/:compute_profile_id/compute_attributes", N_("Create a compute attributes set")
      api :POST, "/compute_profiles/:compute_profile_id/compute_resources/:compute_resource_id/compute_attributes", N_("Create a compute attributes set")
      api :POST, "/compute_resources/:compute_resource_id/compute_attributes", N_("Create a compute attributes set")
      api :POST, "/compute_profiles/:compute_profile_id/compute_attributes", N_("Create a compute attributes set")
      api :POST, "/compute_attributes/", N_("Create a compute attributes set")
      param :compute_profile_id, :identifier, :required => true
      param :compute_resource_id, :identifier, :required => true
      param_group :compute_attribute, :as => :create

      def create
        @compute_attribute = ComputeAttribute.new(compute_attribute_params.merge(
          :compute_profile_id => params[:compute_profile_id],
          :compute_resource_id => params[:compute_resource_id]))
        @compute_attribute.vm_attrs = params[:compute_attribute][:vm_attrs] if params[:compute_attribute].has_key?(:vm_attrs)
        process_response @compute_attribute.save
      end

      api :PUT, "/compute_resources/:compute_resource_id/compute_profiles/:compute_profile_id/compute_attributes/:id", N_("Update a compute attributes set")
      api :PUT, "/compute_profiles/:compute_profile_id/compute_resources/:compute_resource_id/compute_attributes/:id", N_("Update a compute attributes set")
      api :PUT, "/compute_resources/:compute_resource_id/compute_attributes/:id", N_("Update a compute attributes set")
      api :PUT, "/compute_profiles/:compute_profile_id/compute_attributes/:id", N_("Update a compute attributes set")
      api :PUT, "/compute_attributes/:id", N_("Update a compute attributes set")

      param :compute_profile_id, :identifier, :required => false
      param :compute_resource_id, :identifier, :required => false
      param :id, String, :required => true
      param_group :compute_attribute

      def update
        @compute_attribute.attributes = compute_attribute_params
        @compute_attribute.vm_attrs = params[:compute_attribute][:vm_attrs] if params[:compute_attribute].has_key?(:vm_attrs)
        process_response @compute_attribute.save
      end
    end
  end
end
