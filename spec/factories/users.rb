FactoryBot.define do
  factory :user do
    login { "test" }
    admin { false }
    password { "test" }
  end
end
