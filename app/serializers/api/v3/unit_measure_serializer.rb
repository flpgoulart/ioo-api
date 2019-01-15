class Api::V3::UnitMeasureSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :updated_at
end
