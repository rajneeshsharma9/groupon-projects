FactoryBot.define do
  factory :deal do
    title { Faker::Name.name }
    description { Faker::DragonBall.character }
    minimum_purchases_required { 20 }
    maximum_purchases_allowed { 200 }
    price { 20.0 }
    start_at { Time.current + 1.day }
    expire_at { Time.current + 2.day }
    category
  end
end
