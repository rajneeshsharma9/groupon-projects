FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "person#{n}@example.com" }
    password { Tokenizer.new_token[1..10] }
    role { 1 }
    verified_at { Time.current }
  end
end
