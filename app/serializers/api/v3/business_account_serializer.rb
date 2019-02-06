class Api::V3::BusinessAccountSerializer < ActiveModel::Serializer
  attributes :id, :name, :cnpj, :insce, :inscm, :city_name, :uf, :email, :ddd_phone, :phone, :ddd_mobile, :mobile, :address_name, :cep, :plan, :status, :user_id, :created_at, :updated_at

  

  belongs_to :user  
end
