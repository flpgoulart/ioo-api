class Api::V3::ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :logo_default, :subcategory_id, :keywords, :created_at, :updated_at

  belongs_to :subcategory 
end

