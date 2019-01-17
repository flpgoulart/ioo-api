FactoryGirl.define do
    factory :store_campaign do
      status { 'R' }

      user 
      store
      campaign
    end 
  end
