class ShoppingListOffer < ApplicationRecord
  belongs_to :shopping_list
  belongs_to :offer
  belongs_to :user

  validates_presence_of :status
  validates_presence_of :shopping_list_id
  validates_presence_of :offer_id
  validates_presence_of :user_id

end
