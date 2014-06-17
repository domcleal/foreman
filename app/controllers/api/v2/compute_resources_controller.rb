module Api
  module V2
    class ComputeResourcesController < V2::BaseController

      include Api::Version2
      include Api::TaxonomyScope

      before_filter :find_resource, :only => [:show, :update, :destroy, :available_images,
                                              :available_networks, :available_clusters, :available_storage_domains]

      api :GET, "/compute_resources/", N_("List all compute resources")
      param :search, String, :desc => N_("filter results")
      param :order, String, :desc => N_("sort results")
      param :page, String, :desc => N_("paginate results")
      param :per_page, String, :desc => N_("number of entries per request")

      def index
        @compute_resources = resource_scope.search_for(*search_options).paginate(paginate_options)
      end

      api :GET, "/compute_resources/:id/", N_("Show a compute resource")
      param :id, :identifier, :required => true

      def show
      end

      def_param_group :compute_resource do
        param :compute_resource, Hash, :action_aware => true do
          param :name, String
          param :provider, String, :desc => N_("Providers include %s") % ComputeResource.providers.join(', ')
          param :url, String, :required => true, :desc => N_("URL for Libvirt, Ovirt, and Openstack")
          param :description, String
          param :user, String, :desc => N_("Username for Ovirt, EC2, Vmware, Openstack. Access Key for EC2.")
          param :password, String, :desc => N_("Password for Ovirt, EC2, Vmware, Openstack. Secret key for EC2")
          param :uuid, String, :desc => N_("for Ovirt, Vmware Datacenter")
          param :region, String, :desc => N_("for EC2 only")
          param :tenant, String, :desc => N_("for Openstack only")
          param :server, String, :desc => N_("for Vmware")
        end
      end

      api :POST, "/compute_resources/", N_("Create a compute resource")
      param_group :compute_resource, :as => :create

      def create
        @compute_resource = ComputeResource.new_provider(params[:compute_resource])
        process_response @compute_resource.save
      end


      api :PUT, "/compute_resources/:id/", N_("Update a compute resource")
      param :id, String, :required => true
      param_group :compute_resource

      def update
        process_response @compute_resource.update_attributes(params[:compute_resource])
      end

      api :DELETE, "/compute_resources/:id/", N_("Delete a compute resource")
      param :id, :identifier, :required => true

      def destroy
        process_response @compute_resource.destroy
      end

      api :GET, "/compute_resources/:id/available_images/", N_("List available images for a compute resource")
      param :id, :identifier, :required => true
      def available_images
        @available_images = @compute_resource.available_images
      end

      api :GET, "/compute_resources/:id/available_clusters", N_("List available clusters for a compute resource")
      param :id, :identifier, :required => true
      def available_clusters
        @available_clusters = @compute_resource.available_clusters
        render :available_clusters, :layout => 'api/v2/layouts/index_layout'
      end

      api :GET, "/compute_resources/:id/available_networks", N_("List available networks for a compute resource")
      api :GET, "/compute_resources/:id/available_clusters/:cluster_id/available_networks", N_("List available networks for a compute resource cluster")
      param :id, :identifier, :required => true
      param :cluster_id, String
      def available_networks
        @available_networks = @compute_resource.available_networks(params[:cluster_id])
        render :available_networks, :layout => 'api/v2/layouts/index_layout'
      end

      api :GET, "/compute_resources/:id/available_storage_domains", N_("List storage domains for a compute resource")
      param :id, :identifier, :required => true
      def available_storage_domains
        @available_storage_domains = @compute_resource.available_storage_domains
        render :available_storage_domains, :layout => 'api/v2/layouts/index_layout'
      end

      private

      def action_permission
        case params[:action]
          when 'available_images', 'available_clusters', 'available_networks', 'available_storage_domains'
            :view
          else
            super
        end
      end
    end
  end
end
