FactoryBot.define do
  factory :expense do
    amount { 50.0 }
    date { Date.today }
    note { "Sample expense" }
    association :user
    association :category
  end
end
