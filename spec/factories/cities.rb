FactoryGirl.define do
    factory :city do
      name { Faker::Address.city }
      cep_begin { Faker::Number.number(4) }
      cep_end { Faker::Number.number(4) }
      uf { Faker::Address.state_abbr }
    end 
  end