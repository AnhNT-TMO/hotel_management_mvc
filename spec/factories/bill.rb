FactoryBot.define do
  factory :bill, class: Bill do
    status { rand(0...1) }
  end
end
