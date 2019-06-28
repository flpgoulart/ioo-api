class StoreCampaign < ApplicationRecord
  belongs_to :store
  belongs_to :campaign
  belongs_to :user

  validates_presence_of :status
  validates_presence_of :store_id
  validates_presence_of :campaign_id
  validates_presence_of :user_id
  
  validates_uniqueness_of :store_id, scope: :campaign_id
  
  def store_name
    Store.find(store_id).name
  end

end
