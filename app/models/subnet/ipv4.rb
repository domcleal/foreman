require 'socket'

class Subnet::Ipv4 < Subnet
  def family
    Socket::AF_INET
  end

  def validate_ip(ip)
    Net::Validations.validate_ip(ip)
  end

  private

  def cleanup_ip(address)
    super
    address.gsub!(/2555+/, "255")
    address
  end

  def normalize_ip(address)
    Net::Validations.normalize_ip(address)
  end

end
