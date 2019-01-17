class Campaign < ApplicationRecord
  belongs_to :user

  has_many :offers, dependent: :destroy
  has_many :store_campaigns, dependent: :destroy

  validates_presence_of :name
  validates_presence_of :status
  validates_presence_of :end_date
  validates_presence_of :start_date
  validates_presence_of :user_id

end
