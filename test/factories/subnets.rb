FactoryGirl.define do
  factory :subnet do
    sequence(:name) { |n| "subnet #{n}" }

    trait :with_domains do
      ignore do
        domains_count 2
      end

      after_create do |subnet, evaluator|
        FactoryGirl.create_list(:domain, evaluator.domains_count, :subnets => [subnet])
      end
    end

    factory :subnet_ipv4, :class => Subnet::Ipv4 do
      network { 3.times.map { rand(256) }.join('.') + '.0' }
      mask { '255.255.255.0' }

      factory :subnet_ipv4_with_domains, :traits => [:with_domains]
    end

    factory :subnet_ipv6, :class => Subnet::Ipv6 do
      network { 4.times.map { '%x' % rand(16**4) }.join(':') + '::' }
      mask { 4.times.map { 'ffff' }.join(':') + '::' }

      factory :subnet_ipv6_with_domains, :traits => [:with_domains]
    end
  end
end
