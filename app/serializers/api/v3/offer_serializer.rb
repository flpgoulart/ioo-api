class Api::V3::OfferSerializer < ActiveModel::Serializer
  attributes :id, :name, :brand_name, :disclaimer, :status, :product_value, :offer_value, :user_id, :product_id, :campaign_id, :unit_measure_id, :qty_views, :created_at, :updated_at

  belongs_to :user  
  belongs_to :product
  belongs_to :campaign
  belongs_to :unit_measure

end