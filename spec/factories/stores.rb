FactoryGirl.define do
    factory :store do
      name { Faker::Lorem.sentence }
      cep { Faker::Address.postcode }
      address_name { Faker::Address.full_address }
      contact_info { Faker::Lorem.sentence }
      status { 'A' }
      
      store_type
      business
      city
      user
    end 
  end


