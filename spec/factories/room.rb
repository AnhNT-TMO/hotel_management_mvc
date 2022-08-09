FactoryBot.define do
  factory :room, class: Room do
    name { Faker::Name.unique.name }
    price { rand(1000...2000) }
    types { 3 }
  end
end
