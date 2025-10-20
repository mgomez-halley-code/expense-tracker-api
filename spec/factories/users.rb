FactoryBot.define do
  factory :user do
    email { "user_#{rand(1000)}@example.com" }
    password { "password123" }
  end
end

