class Api::V3::SocialEntitySerializer < ActiveModel::Serializer
  attributes :id, :name, :about_us, :phone_number, :mobile_number, :email_contact, 
             :site, :address, :user_id, :target_audience_id, :occupation_area_id, :created_at, :updated_at,
             :you_are_a, :facebook_url, :address_comp, :cnpj_no

  belongs_to :user
  belongs_to :target_audience
  belongs_to :occupation_area
  
end
