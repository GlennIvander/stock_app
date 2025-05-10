FactoryBot.define do
  factory :portfolio do
    association :user
    symbol { "MSFT" }
    total_shares { 100 }
  end
end
