class Api::V3::PersonalPageSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :category_id, :created_at, :updated_at

  belongs_to :category 
  belongs_to :user 
  
end
