FactoryBot.define do
  factory :user do
    sequence(:name) { |i| "john doe #{i}" }
    email { "test@example.com" }
  end
end
