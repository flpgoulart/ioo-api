FactoryGirl.define do 
    factory :improvement do

        title { Faker::Lorem.sentence }
        short_description { Faker::Lorem.paragraph }
        description { Faker::Lorem.paragraph }
        address {Faker::Address.street_address}
        address_comp { Faker::Address.secondary_address }
        limit_volunteers { Faker::Number.number(3) }
        start_date { Faker::Date.forward }
        end_date { Faker::Date.forward }
        knowledge_required { Faker::Lorem.paragraph }
        support_materials { Faker::Lorem.paragraph }
        people_benefited { Faker::Number.number(4) }
        status {'R'}

        social_entity

    end 

end 