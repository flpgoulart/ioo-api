FactoryGirl.define do
    factory :subcategory do
      name { Faker::Lorem.sentence }
      description { Faker::Lorem.paragraph }
      logo { Faker::Avatar.image }
      market_session { Faker::Lorem.sentence }

      category
    end 
  end