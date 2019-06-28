class Api::V3::StoreCampaignSerializer < ActiveModel::Serializer
  attributes :id, :status, :store_id, :campaign_id, :user_id, :created_at, :updated_at, :store_name

  belongs_to :user  
  belongs_to :store
  belongs_to :campaign
  
end
