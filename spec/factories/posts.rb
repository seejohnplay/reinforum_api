FactoryGirl.define do
  factory :post do
    author { Faker::Name.name }
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraphs }
    category
  end
end
