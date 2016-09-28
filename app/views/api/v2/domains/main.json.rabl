object @domain

extends "api/v2/domains/base"

attributes :fullname, :dns_id, :created_at, :updated_at

@object.smart_proxies.keys.each do |proxy|
  child proxy => proxy do
    extends "api/v2/smart_proxies/base"
  end
end
