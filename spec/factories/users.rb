FactoryBot.define do
  factory :user do
    login { "MyString" }
    password { "MyString" }
    admin { false }
  end
end
