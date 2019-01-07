FactoryGirl.define do 
    factory :social_entity do

        name { Faker::Company.name }
        you_are_a { Faker::Lorem.sentence }
        facebook_url { Faker::Internet.url }
        address_comp { Faker::Address.secondary_address }
        cnpj_no { Faker::Company.duns_number }
        about_us { Faker::Lorem.paragraph }
        phone_number {Faker::Company.ein}
        mobile_number {Faker::Company.ein}
        email_contact {Faker::Internet.email}
        site {Faker::Internet.domain_name}
        address {Faker::Address.street_address}
        
        #como no modelo temos o belongs_to para user, o FactoryGirl cria automaticamente um usuário utilizando a associação
        user
        target_audience
        occupation_area
    end 

end 