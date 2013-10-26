require 'socket'

class Subnet::Ipv6 < Subnet
  def family
    Socket::AF_INET6
  end

  def validate_ip(ip)
    Net::Validations.validate_ip6(ip)
  end

  private

  def normalize_ip(address)
    Net::Validations.normalize_ip6(address)
  end

end
