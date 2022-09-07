FactoryBot.define do
  factory :bill, class: Bill do
    status { 1 }
    total_price { 10000 }
  end
end
