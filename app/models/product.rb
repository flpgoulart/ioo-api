class Product < ApplicationRecord
  belongs_to :subcategory

  validates_presence_of :name
  validates_presence_of :subcategory_id


end
