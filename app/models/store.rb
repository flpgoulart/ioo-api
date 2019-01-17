class Store < ApplicationRecord
  belongs_to :store_type
  belongs_to :business
  belongs_to :city
  belongs_to :user

  validates_presence_of :name
  validates_presence_of :user_id
  validates_presence_of :store_type_id
  validates_presence_of :business_id
  validates_presence_of :city_id
  validates_presence_of :cep
  validates_presence_of :address_name
  validates_presence_of :status

end
