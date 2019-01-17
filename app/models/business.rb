class Business < ApplicationRecord
  belongs_to :user

  has_many :stores, dependent: :destroy

  validates_presence_of :name
  validates_presence_of :user_id 
  
end
