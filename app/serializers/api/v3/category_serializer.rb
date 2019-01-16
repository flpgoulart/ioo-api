class Api::V3::CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :logo, :created_at, :updated_at
end
