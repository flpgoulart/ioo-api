FactoryGirl.define do
    factory :shopping_list do
      name { Faker::Lorem.sentence }

      user 
    end 
  end

  
