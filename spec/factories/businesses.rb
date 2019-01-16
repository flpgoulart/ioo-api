FactoryGirl.define do
    factory :business do
      name { Faker::Lorem.sentence }
      about_us { Faker::Lorem.paragraph }
      url_site { Faker::Internet.url }
      url_facebook{ Faker::Internet.url }
      contact_info{ Faker::Address.full_address }

      user 
    end 
  end

