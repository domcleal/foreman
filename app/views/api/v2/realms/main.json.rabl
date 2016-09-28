object @realm
extends "api/v2/realms/base"
attributes :name, :realm_proxy_id, :realm_type, :created_at, :updated_at

@object.smart_proxies.keys.each do |proxy|
  child proxy => proxy do
    extends "api/v2/smart_proxies/base"
  end
end
