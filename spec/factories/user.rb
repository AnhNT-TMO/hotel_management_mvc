FactoryBot.define do
  factory :user, class: User do
    name { Faker::Name.unique.name }
    email { Faker::Internet.email(domain: "sun-asterisk.com") }
    password { "123456" }
    password_confirmation { "123456" }
    phone { Faker::PhoneNumber.cell_phone_in_e164 }
  end
end
