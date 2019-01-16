class Api::V3::BusinessSerializer < ActiveModel::Serializer
  attributes :id, :name, :about_us, :url_site, :url_facebook, :contact_info, :user_id, :created_at, :updated_at

  belongs_to :user  
end
