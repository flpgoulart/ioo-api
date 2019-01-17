class Product < ApplicationRecord
  belongs_to :subcategory

  has_many :offers, dependent: :destroy

  validates_presence_of :name
  validates_presence_of :subcategory_id


end
