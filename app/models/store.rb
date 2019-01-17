class Store < ApplicationRecord
  belongs_to :store_type
  belongs_to :business
  belongs_to :city
  belongs_to :user
end
