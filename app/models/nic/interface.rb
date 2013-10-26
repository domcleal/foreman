module Nic
  class Interface < Base

    attr_accessible :ip, :ip6

    before_validation :normalize_ip
    validates :ip, :uniqueness => true, :allow_blank => true, :allow_nil => true
    validates :ip6, :uniqueness => true, :allow_blank => true, :allow_nil => true
    validate :ip_presence_and_formats

    protected

    def uniq_fields_with_hosts
      super.push(:ip, :ip6)
    end

    def ip_presence_and_formats
      errors.add(:base, _("Either an IPv4 or IPv6 address must be supplied")) unless ip.present? || ip6.present?
      errors.add(:ip, _("is invalid")) if ip.present? && !Net::Validations.validate_ip(ip)
      errors.add(:ip6, _("is invalid")) if ip6.present? && !Net::Validations.validate_ip6(ip6)
    end

    def normalize_ip
      self.ip = Net::Validations.normalize_ip(ip) if ip.present?
      self.ip6 = Net::Validations.normalize_ip6(ip6) if ip6.present?
    end

  end
end
