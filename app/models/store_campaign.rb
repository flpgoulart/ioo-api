class StoreCampaign < ApplicationRecord
  belongs_to :store
  belongs_to :campaign
  belongs_to :user

  validates_presence_of :status
  validates_presence_of :store_id
  validates_presence_of :campaign_id
  validates_presence_of :user_id

end
