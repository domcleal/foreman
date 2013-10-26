FactoryGirl.define do
  factory :nic, :class => Nic::Base do
    mac { 6.times.map { '%0.2X' % rand(256) }.join(':') }

    association :host, :factory => :host_managed

    factory :nic_interface, :class => Nic::Interface do
      trait :with_ipv4 do
        ip { 4.times.map { rand(256) }.join('.') }
      end
      trait :with_ipv6 do
        ip6 { 8.times.map { '%x' % rand(16**4) }.join(':') }
      end

      factory :nic_managed, :class => Nic::Managed do
        sequence(:name) { |n| "nic-#{n}" }
      end
    end
  end
end
