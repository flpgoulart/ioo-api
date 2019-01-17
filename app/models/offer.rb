class Offer < ApplicationRecord
  belongs_to :product
  belongs_to :campaign
  belongs_to :unit_measure
  belongs_to :user
end
