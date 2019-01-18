class ShoppingList < ApplicationRecord
  belongs_to :user

  has_many :shopping_list_offers, dependent: :destroy
  
  validates_presence_of :name
  validates_presence_of :user_id

  
end
