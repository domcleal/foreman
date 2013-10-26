FactoryGirl.define do
  factory :host, :class => Host::Base do
    sequence(:name) { |n| "host-#{n}" }

    factory :host_managed, :class => Host::Managed do
      environment

      trait :with_ipv4 do
        association :subnet, { :factory => :subnet_ipv4_with_domains }
        domain { subnet.domains.first }
        ip { IPAddr.new(subnet.ipaddr.to_i + 1, subnet.family).to_s }
      end

      trait :with_ipv6 do
        association :subnet6, { :factory => :subnet_ipv6_with_domains }
        domain { subnet6.domains.first }
        ip6 { IPAddr.new(subnet6.ipaddr.to_i + 1, subnet6.family).to_s }
      end
    end
  end
end
