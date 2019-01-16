FactoryGirl.define do
    factory :campaign do
      name { Faker::Lorem.sentence }
      disclaimer { Faker::Lorem.paragraph }
      start_date { Faker::Date.between(Date.today, 10.days.from_now) }
      end_date { Faker::Date.between(10.days.from_now, 40.days.from_now) }
      status { 'R' }

      user 
    end 
  end

  
