FactoryGirl.define do
    factory :shopping_list_offer do
      status { 'P' }

      user 
      shopping_list
      offer
    end 
  end

  
