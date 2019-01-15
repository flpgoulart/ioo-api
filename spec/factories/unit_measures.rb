FactoryGirl.define do
    factory :unit_measure do
      name { Faker::Measurement.height("none") }
    end 
  end