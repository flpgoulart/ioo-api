class ShoppingListOffer < ApplicationRecord
  belongs_to :shopping_list
  belongs_to :offer
  belongs_to :user
end
