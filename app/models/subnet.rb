require 'ipaddr'
class Subnet < ActiveRecord::Base
  include Authorization
  include Foreman::STI
  include Taxonomix

  IP_FIELDS = [:network, :mask, :gateway, :dns_primary, :dns_secondary, :from, :to]
  REQUIRED_IP_FIELDS = [:network, :mask]

  before_destroy EnsureNotUsedBy.new(:hosts, :interfaces )
  has_many_hosts
  has_many :hostgroups
  belongs_to :dhcp, :class_name => "SmartProxy"
  belongs_to :tftp, :class_name => "SmartProxy"
  belongs_to :dns,  :class_name => "SmartProxy"
  has_many :subnet_domains, :dependent => :destroy
  has_many :domains, :through => :subnet_domains
  has_many :interfaces, :class_name => 'Nic::Base'
  validates :network, :mask, :name, :presence => true
  validates_associated    :subnet_domains
  validates :network, :uniqueness => true

  before_validation :cleanup_addresses
  before_validation :normalize_addresses
  validate :ensure_ip_addrs_valid
  validate :name_should_be_uniq_across_domains
  validate :validate_ranges

  default_scope lambda {
    with_taxonomy_scope do
      order('vlanid')
    end
  }

  scoped_search :on => [:name, :network, :mask, :gateway, :dns_primary, :dns_secondary, :vlanid], :complete_value => true
  scoped_search :in => :domains, :on => :name, :rename => :domain, :complete_value => true

  class Jail < ::Safemode::Jail
    allow :name, :network, :mask, :cidr, :title, :to_label, :gateway, :dns_primary, :dns_secondary, :vlanid
  end

  # Subnets are displayed in the form of their network network/network mask
  def to_label
    "#{network}/#{cidr}"
  end

  def title
    "#{name} (#{to_label})"
  end

  # Subnets are sorted on their priority value
  # [+other+] : Subnet object with which to compare ourself
  # +returns+ : Subnet object with higher precedence
  def <=> (other)
    if self.vlanid.present? && other.vlanid.present?
      self.vlanid <=> other.vlanid
    else
      return -1
    end
  end

  # Given an IP returns the subnet that contains that IP
  # [+ip+] : "doted quad" string
  # Returns : Subnet object or nil if not found
  def self.subnet_for(ip)
    ip = IPAddr.new(ip)
    Subnet.all.each {|s| return s if s.family == ip.family && s.contains?(ip)}
    nil
  end

  # Indicates whether the IP is within this subnet
  # [+ip+] String: IPv4 or IPv6 address
  # Returns Boolean: True if if ip is in this subnet
  def contains? ip
    ipaddr.include? IPAddr.new(ip, family)
  end

  def ipaddr
    IPAddr.new("#{network}/#{mask}", family)
  end

  def cidr
    IPAddr.new(mask).to_i.to_s(2).count("1")
  end

  def dhcp?
    !!(dhcp and dhcp.url and !dhcp.url.blank?)
  end

  def dhcp_proxy attrs = {}
    @dhcp_proxy ||= ProxyAPI::DHCP.new({:url => dhcp.url}.merge(attrs)) if dhcp?
  end

  def tftp?
    !!(tftp and tftp.url and !tftp.url.blank?)
  end

  def tftp_proxy attrs = {}
    @tftp_proxy ||= ProxyAPI::TFTP.new({:url => tftp.url}.merge(attrs)) if tftp?
  end

  # do we support DNS PTR records for this subnet
  def dns?
    !!(dns and dns.url and !dns.url.blank?)
  end

  def dns_proxy attrs = {}
    @dns_proxy ||= ProxyAPI::DNS.new({:url => dns.url}.merge(attrs)) if dns?
  end

  def unused_ip mac = nil
    return unless dhcp?
    dhcp_proxy.unused_ip(self, mac)["ip"]
  rescue => e
    logger.warn "Failed to fetch a free IP from our proxy: #{e}"
    nil
  end

  # imports subnets from a dhcp smart proxy
  def self.import proxy
    return unless proxy.features.include?(Feature.find_by_name("DHCP"))
    ProxyAPI::DHCP.new(:url => proxy.url).subnets.map do |s|
      # do not import existing networks.
      attrs = { :network => s["network"], :mask => s["netmask"] }
      next if first(:conditions => attrs)
      new(attrs.update(:dhcp => proxy))
    end.compact
  end

  private

  def validate_ranges
    if from.present? or to.present?
      errors.add(:from, _("must be specified if to is defined"))   if from.blank?
      errors.add(:to,   _("must be specified if from is defined")) if to.blank?
    end
    return if errors.keys.include?(:from) || errors.keys.include?(:to)
    errors.add(:from, _("does not belong to subnet"))     if from.present? and not self.contains?(f=IPAddr.new(from))
    errors.add(:to, _("does not belong to subnet"))       if to.present?   and not self.contains?(t=IPAddr.new(to))
    errors.add(:from, _("can't be bigger than to range")) if from.present? and t.present? and f > t
  end

  def name_should_be_uniq_across_domains
    return if domains.empty?
    domains.each do |d|
      conds = new_record? ? ['name = ?', name] : ['subnets.name = ? AND subnets.id != ?', name, id]
      errors.add(:name, _("domain %s already has a subnet with this name") % d) if d.subnets.where(conds).first
    end
  end

  def cleanup_addresses
    IP_FIELDS.each do |f|
      send("#{f}=", cleanup_ip(send(f))) if send(f).present?
    end
    self
  end

  def cleanup_ip(address)
    address.gsub!(/\.\.+/, ".")
    address
  end

  def normalize_addresses
    IP_FIELDS.each do |f|
      val = send(f)
      send("#{f}=", normalize_ip(val)) if val.present?
    end
    self
  end

  def ensure_ip_addrs_valid
    IP_FIELDS.each do |f|
      errors.add(f, _("is invalid")) if (send(f).present? || REQUIRED_IP_FIELDS.include?(f)) && !validate_ip(send(f)) && !errors.keys.include?(f)
    end
  end

  # Permit equal access to all subclasses
  def effective_permissions_class
    ['subnets', _("subnet")]
  end

end
