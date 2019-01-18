class Api::V3::ShoppingListSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id, :created_at, :updated_at

  belongs_to :user  
end
