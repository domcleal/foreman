object @subnet

extends "api/v2/subnets/base"

attributes :network, :network_type, :cidr, :mask, :priority, :vlanid, :gateway,
           :dns_primary, :dns_secondary,
           :from, :to, :created_at, :updated_at, :ipam, :boot_mode

Subnet.smart_proxies.keys.each do |proxy|
  child proxy => proxy do
    extends "api/v2/smart_proxies/base"
  end
end
