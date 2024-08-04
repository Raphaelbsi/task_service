FactoryBot.define do
  factory :scraping_result do
    task_id { 1 }
    user_id { 1 }
    make { "MyString" }
    model { "MyString" }
    price { "MyString" }
  end
end
