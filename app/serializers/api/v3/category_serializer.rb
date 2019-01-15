class Api::V3::CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :logo 
end
