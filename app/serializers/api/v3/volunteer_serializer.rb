class Api::V3::VolunteerSerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :address_comp, :status, :user_id, :created_at, :updated_at

  belongs_to :user

end
