FactoryGirl.define do
  factory :comment do
    author { Faker::Name.name }
    body { Faker::Lorem.sentence }
    post
  end
end
