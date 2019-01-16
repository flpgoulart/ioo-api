FactoryGirl.define do
    factory :store_type do
      name { Faker::Lorem.sentence }
    end 
  end