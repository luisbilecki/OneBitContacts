FactoryBot.define do
  factory :contact do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    description { Faker::Fallout.quote }
    user
  end
end
