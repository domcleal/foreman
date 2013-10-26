FactoryGirl.define do
  factory :environment do
    sequence(:name) { |n| "env#{n}" }
  end
end
