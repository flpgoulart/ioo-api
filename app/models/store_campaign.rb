class StoreCampaign < ApplicationRecord
  belongs_to :store
  belongs_to :campaign
  belongs_to :user
end
