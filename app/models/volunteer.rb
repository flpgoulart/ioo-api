class Volunteer < ApplicationRecord
  belongs_to :user

  has_many :volunteer_lists, dependent: :destroy
  
  validates_presence_of :name, :address, :user_id
end
