FactoryGirl.define do
    factory :billing do

      document { Faker::Number.number(10) }
      doc_date { Faker::Date.between(Date.today, 2.days.from_now) }
      ref_ini_date { Faker::Date.between(Date.today, 2.days.from_now) }
      ref_end_date { Faker::Date.between(15.days.from_now, 32.days.from_now) }
      link_document { Faker::Internet.url }
      status { 'P' } #Pendente de pagamento
      
      user 
    end 
  end

  