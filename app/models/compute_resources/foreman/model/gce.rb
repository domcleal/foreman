module Foreman::Model
  class GCE < ComputeResource
    has_one :key_pair, :foreign_key => :compute_resource_id, :dependent => :destroy
    before_create :setup_key_pair
    validate :check_google_key_path
    validates :key_path, :project, :email, :presence => true

    delegate :flavors, :to => :client

    def to_label
      "#{name} (#{zone}-#{provider_friendly_name})"
    end

    def capabilities
      [:image]
    end

    def project
      attrs[:project]
    end

    def project=(name)
      attrs[:project] = name
    end

    def key_path
      attrs[:key_path]
    end

    def key_path=(name)
      attrs[:key_path] = name
    end

    def email
      attrs[:email]
    end

    def email=(email)
      attrs[:email] = email
    end

    # TODO: allow to select public / private ip address that foreman tries to find
    #       through provided_attributes, with external_ip enabled or disabled

    def zones
      client.list_zones.body['items'].map { |zone| zone['name'] }
    end

    def networks
      client.list_networks.body['items'].map { |n| n['name'] }
    end

    def disks
      client.list_disks(zone).body['items'].map { |disk| disk['name'] }
    end

    def zone
      url
    end

    def zone=(zone)
      self.url = zone
    end

    def create_vm(args = {})
      # Dots are not allowed in names
      args[:name]        = args[:name].parameterize if args[:name].present?
      args[:external_ip] = args[:external_ip] != '0'
      args[:image_name]  = args[:image_id]
      # GCE network interfaces cannot be defined though Foreman yet
      args[:network_interfaces] = nil
      args[:disks]       = [create_disk(args[:name], args[:volumes][:size_gb], args[:image_id])]
      args[:disks].first.wait_for { args[:disks].first.ready? }

      username = images.where(:uuid => args[:image_name]).first.try(:username)
      ssh      = { :username => username, :public_key => key_pair.public }
      super(args.merge(ssh))
    rescue Fog::Errors::Error => e
      args[:disks].map(&:destroy) if args[:disks].present?
      logger.error "Unhandled GCE error: #{e.class}:#{e.message}\n " + e.backtrace.join("\n ")
      raise e
    end

    def available_images
      client.images
    end

    def create_disk(name, size, image_uuid)
      client.disks.create(
        :name         => name,
        :size_gb      => size.to_i,
        :zone_name    => zone,
        :source_image => client.images.select { |i| i.id == image_uuid }.first.name
      )
    end

    def self.model_name
      ComputeResource.model_name
    end

    def setup_key_pair
      require 'sshkey'
      name = "foreman-#{id}#{Foreman.uuid}"
      key  = ::SSHKey.generate
      build_key_pair :name => name, :secret => key.private_key, :public => key.ssh_public_key
    end

    def test_connection(options = {})
      super
      errors[:user].empty? and errors[:password].empty? and zones
    rescue => e
      errors[:base] << e.message
    end

    def self.provider_friendly_name
      "Google"
    end

    def interfaces_attrs_name
      :network_interfaces
    end

    def new_volume(attrs = { })
      client.disks.new(:zone => zone)
    end

    private

    def client
      @client ||= ::Fog::Compute.new(:provider => 'google', :google_project => project, :google_client_email => email, :google_key_location => key_path)
    end

    def check_google_key_path
      return if key_path.blank?
      unless File.exist?(key_path)
        errors.add(:key_path, _('Unable to access key'))
      end
    rescue => e
      logger.warn("failed to access gce key path: #{e}")
      logger.debug(e.backtrace)
      errors.add(:key_path, e.message.to_s)
    end

    def vm_instance_defaults
      super.merge(
        :zone => zone,
        :name => "foreman-#{Time.now.to_i}"
      )
    end
  end
end
