FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "person#{n}@example.com" }
    password { Tokenizer.new_token[1..10] }
    verified_at { Time.current }

    factory :customer do
      role { 0 }
    end

    factory :admin do
      role { 1 }
    end

    factory :merchant do
      role { 2 }
    end

  end
end
