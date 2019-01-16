class Api::V3::CampaignSerializer < ActiveModel::Serializer
  attributes :id, :name, :disclaimer, :start_date, :end_date, :status, :user_id, :created_at, :updated_at

  belongs_to :user  

end
