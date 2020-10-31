FactoryBot.define do
  factory :order do
    user_id { 1 }
    code { "MyString" }
    quantity { 1 }
  end
end
