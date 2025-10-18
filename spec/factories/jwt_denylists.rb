FactoryBot.define do
  factory :jwt_denylist do
    jti { "MyString" }
    exp { "2025-10-18 13:05:52" }
  end
end
