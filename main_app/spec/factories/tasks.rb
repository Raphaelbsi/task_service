FactoryBot.define do
  factory :task do
    title { 'My Task' }
    status { :pending }
    url { 'http://example.com' }
    user_id { 1 }
  end
end
