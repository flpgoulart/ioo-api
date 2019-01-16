class Api::V3::StoreTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :updated_at
end
