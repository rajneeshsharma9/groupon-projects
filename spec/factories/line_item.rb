FactoryBot.define do
  factory :line_item do
    association :deal, factory: :deal, published_at: Time.current
    order
    price_per_quantity { 20 }
    quantity { 4 }
  end
end
