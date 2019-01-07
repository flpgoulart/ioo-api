FactoryGirl.define do 
    factory :volunteer_list do

        volunteer 
        improvement

        attendance false
        rate_volunteer { Faker::Number.number(1) }
        rate_improvement { Faker::Number.number(1) }
        rate_social_entity { Faker::Number.number(1) }

    end 

end 