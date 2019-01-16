class Api::V3::SubcategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :logo, :market_session, :category_id, :created_at, :updated_at

  belongs_to :category 
end
