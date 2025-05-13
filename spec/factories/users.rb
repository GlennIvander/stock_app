FactoryBot.define do
  factory :user do
    email { "test@example.com" }
    password { "*Password123" }
    confirmed_at { Time.current }
    is_pending { false }
  end
end
