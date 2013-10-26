FactoryGirl.define do
  factory :domain do
    sequence(:name) {|n| "#{n}.example.com" }
    sequence(:fullname) {|n| "Domain object for #{n}" }
  end
end
