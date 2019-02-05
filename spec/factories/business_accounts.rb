FactoryGirl.define do
    factory :business_account do
      name { Faker::Company.name }
      cnpj { Faker::Company.french_siret_number }
      insce { Faker::Company.polish_taxpayer_identification_number }
      inscm { Faker::Company.czech_organisation_number } 

      email { Faker::Internet.email }

      ddd_phone { Faker::Number.number(2) }
      phone { Faker::Company.norwegian_organisation_number } 

      ddd_mobile { Faker::Number.number(2) }
      mobile { Faker::Company.norwegian_organisation_number } 

      city_name { Faker::Address.city }
      uf { Faker::Address.state_abbr }
      address_name { Faker::Address.full_address }
      cep { Faker::Address.zip }  

      plan { 'B' } #Empresarial
      status { 'P' } #Pendente para analise
      
      user 
    end 
  end

