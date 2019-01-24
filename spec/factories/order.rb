FactoryBot.define do
  factory :order do
    user
    workflow_state { "cart" }
    amount { 40 }
    receiver_email { 'abc@gmail.com' }
  end
end
