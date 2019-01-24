FactoryBot.define do
  factory :location do
    sequence(:name) { |n| "location#{n} name" }
    address
  end
end
