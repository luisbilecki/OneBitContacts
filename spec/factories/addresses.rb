FactoryBot.define do
  factory :address do
    name {Faker::Address.street_name}
    contact
  end
end
