FactoryGirl.define do
    factory :business_account do
      name { Faker::Company.name }
      cnpj { Faker::Number.number(14) }
      insce { Faker::Number.number(12) }
      inscm { Faker::Number.number(12) } 

      email { Faker::Internet.email }

      ddd_phone { Faker::Number.number(2) }
      phone { Faker::Number.number(8) } 

      ddd_mobile { Faker::Number.number(2) }
      mobile { Faker::Number.number(9) } 

      city_name { Faker::Address.city }
      uf { Faker::Address.state_abbr }
      address_name { Faker::Address.full_address }
      cep { Faker::Address.zip }  

      plan { 'B' } #Empresarial
      status { 'P' } #Pendente para analise
      
      user 
    end 
  end

