FactoryGirl.define do
  factory :category do
    name { Faker::Lorem.word }
    url { name }
  end
end