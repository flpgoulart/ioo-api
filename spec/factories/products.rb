FactoryGirl.define do
    factory :product do
      name { Faker::Lorem.sentence }
      logo_default { Faker::Avatar.image } 
      keywords { Faker::Lorem.paragraph }

      subcategory
    end 
  end