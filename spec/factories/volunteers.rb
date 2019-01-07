FactoryGirl.define do 
    factory :volunteer do

        name { Faker::Name.name }
        address { Faker::Address.street_address }
        address_comp { Faker::Address.secondary_address }
        status {'A'}
        
        #como no modelo temos o belongs_to para user, o FactoryGirl cria automaticamente um usuário utilizando a associação
        user
    end 

end 