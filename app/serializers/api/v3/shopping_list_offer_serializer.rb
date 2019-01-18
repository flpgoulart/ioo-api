class Api::V3::ShoppingListOfferSerializer < ActiveModel::Serializer
  attributes :id, :status, :shopping_list_id, :offer_id, :user_id, :created_at, :updated_at

  belongs_to :user  
  belongs_to :shopping_list  
  belongs_to :offer  
  
end
