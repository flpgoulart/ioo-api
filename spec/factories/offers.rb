FactoryGirl.define do
    factory :offer do
      name { Faker::Commerce.product_name }
      brand_name { Faker::Commerce.department }
      disclaimer { Faker::Lorem.paragraph }
      product_value { Faker::Commerce.price }
      offer_value { Faker::Commerce.price }
      status { 'R' }
  
      product
      campaign
      unit_measure
      user 
    end 
  end

  
  

  
  
  