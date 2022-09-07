FactoryBot.define do
  factory :booking, class: Booking do
    start_date { DateTime.now.to_date }
    end_date { 2.days.from_now.to_date }
    total_price { 1 }
    status { 0 }
  end
end
