FactoryGirl.define do
    factory :category do
      name { Faker::Lorem.sentence }
      description { Faker::Lorem.paragraph }
      logo { Faker::Avatar.image }
    end 
  end