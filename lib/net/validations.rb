require 'ipaddr'
require 'socket'

module Net
  module Validations

    IP_REGEXP  = /\A(\d{1,3}\.){3}\d{1,3}\Z/
    MAC_REGEXP = /\A([a-f0-9]{1,2}:){5}[a-f0-9]{1,2}\Z/i
    class Error < RuntimeError;
    end

    class << self
      include Net::Validations
    end

    # validates an IPV4 address
    def validate_ip ip
      IPAddr.new(ip, Socket::AF_INET) rescue return false
      true
    end

    # validates an IPv4p address and raises an error
    def validate_ip! ip
      raise Error, "Invalid IP Address #{ip}" unless validate_ip(ip)
      ip
    end

    # validates an IPv6 address
    def validate_ip6 ip
      IPAddr.new(ip, Socket::AF_INET6) rescue return false
      true
    end

    # validates an IPv6 address and raises an error
    def validate_ip6! ip
      raise Error, "Invalid IPv6 Address #{ip}" unless validate_ip6(ip)
      ip
    end

    # validates the mac
    def validate_mac mac
      raise Error, "Invalid MAC #{mac}" unless (mac =~ MAC_REGEXP)
      mac
    end

    def validate_network network
      validate_ip(network) || raise(Error, "Invalid Network #{network}")
      network
    end

    # ensures that the ip address does not contain any leading spaces or invalid strings
    def normalize_ip ip
      return ip unless ip.present?
      return ip unless ip =~ IP_REGEXP
      ip.split(".").map(&:to_i).join(".")
    end

    # return the most efficient form of a v6 address
    def normalize_ip6 ip
      return ip unless ip.present?
      IPAddr.new(ip, Socket::AF_INET6).to_s rescue ip
    end

    def normalize_mac mac
      return unless mac.present?
      m = mac.downcase
      case m
        when /[a-f0-9]{12}/
          m.gsub(/(..)/) { |mh| mh + ":" }[/.{17}/]
        when /([a-f0-9]{1,2}:){5}[a-f0-9]{1,2}/
          m.split(":").map { |nibble| "%02x" % ("0x" + nibble) }.join(":")
        when /([a-f0-9]{1,2}-){5}[a-f0-9]{1,2}/
          m.split("-").map { |nibble| "%02x" % ("0x" + nibble) }.join(":")
      end
    end
  end
end
