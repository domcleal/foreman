module Api
  module V2
    class MediaController < V2::BaseController

      include Api::Version2
      include Api::TaxonomyScope

      before_filter :find_resource, :only => %w{show update destroy}

      # TRANSLATORS: API documentation - do not translate
      PATH_INFO = <<-eos
The path to the medium, can be a URL or a valid NFS server (exclusive of the architecture).

for example http://mirror.centos.org/centos/$version/os/$arch
where $arch will be substituted for the host\'s actual OS architecture and $version, $major and $minor
will be substituted for the version of the operating system.

Solaris and Debian media may also use $release.
      eos

      # TRANSLATORS: API documentation - do not translate
      OS_FAMILY_INFO = <<-eos
The family that the operating system belongs to.

Available families:

#{Operatingsystem.families.map { |f| "* " + f }.join("\n")}
      eos

      api :GET, "/media/", N_("List all media.")
      param :search, String, :desc => N_("filter results"), :required => false
      param :order, String, :desc => N_("sort results, e.g.: name ASC, or name DESC"), :required => false
      param :page, String, :desc => N_("paginate results")
      param :per_page, String, :desc => N_("number of entries per request")

      def index
        @media = Medium.
          authorized(:view_media).
          search_for(*search_options).paginate(paginate_options)
      end

      api :GET, "/media/:id/", N_("Show a medium.")
      param :id, :identifier, :required => true

      def show
      end

      def_param_group :medium do
        param :medium, Hash, :action_aware => true do
          param :name, String, :required => true, :desc => N_("Name of media")
          param :path, String, :required => true, :desc => PATH_INFO
          param :os_family, String, :require => false, :desc => OS_FAMILY_INFO
          param :operatingsystem_ids, Array, :require => false
        end
      end

      api :POST, "/media/", N_("Create a medium.")
      param_group :medium, :as => :create

      def create
        @medium = Medium.new(params[:medium])
        process_response @medium.save
      end

      api :PUT, "/media/:id/", N_("Update a medium.")
      param :id, String, :required => true
      param_group :medium

      def update
        process_response @medium.update_attributes(params[:medium])
      end

      param :id, :identifier, :required => true
      api :DELETE, "/media/:id/", N_("Delete a medium.")

      def destroy
        process_response @medium.destroy
      end

    end
  end
end
