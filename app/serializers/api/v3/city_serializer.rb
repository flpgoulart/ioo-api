class Api::V3::CitySerializer < ActiveModel::Serializer
  attributes :id, :name, :cep_begin, :cep_end, :uf, :created_at, :updated_at

end