class SocialEntity < ApplicationRecord
  belongs_to :user
  belongs_to :target_audience
  belongs_to :occupation_area

  has_many :improvements, dependent: :destroy

  validates_presence_of :name, :address, :user_id, :target_audience_id, :occupation_area_id, :you_are_a
end
