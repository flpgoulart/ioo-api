class Offer < ApplicationRecord
  belongs_to :product
  belongs_to :campaign
  belongs_to :unit_measure
  belongs_to :user

  has_many :shopping_list_offers, dependent: :destroy
  
  validates_presence_of :name
  validates_presence_of :user_id
  validates_presence_of :product_id
  validates_presence_of :campaign_id
  validates_presence_of :unit_measure_id
  validates_presence_of :product_value
  validates_presence_of :offer_value
  validates_presence_of :brand_name


end
