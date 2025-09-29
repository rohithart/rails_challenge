FactoryBot.define do
  factory :order do
    association :user
    total { rand(10..200) }
    created_at { rand(1..60).days.ago }
  end
end
