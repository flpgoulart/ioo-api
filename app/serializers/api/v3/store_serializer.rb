class Api::V3::StoreSerializer < ActiveModel::Serializer
  attributes :id, :name, :cep, :address_name, :contact_info, :status, :store_type_id, :business_id, :city_id, :user_id, :created_at, :updated_at

  belongs_to :user  
  belongs_to :store_type
  belongs_to :business
  belongs_to :city

end
