FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { Faker::Internet.unique.email.downcase }

    trait :with_orders do
      transient { orders_count { 5 } }

      after(:create) do |user, evaluator|
        create_list(:order, evaluator.orders_count, user: user)
      end
    end
  end
end
