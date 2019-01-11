FactoryBot.define do
  factory :line_item do
    deal
    order
    price_per_quantity { 20 }
    quantity { 4 }
  end
end
