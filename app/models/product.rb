class Product < ApplicationRecord
  belongs_to :subcategory

  has_many :offers, dependent: :destroy

  validates_presence_of :name
  validates_presence_of :subcategory_id

  def subcategory_name
    Category.find(Subcategory.find(subcategory_id).category_id).name + "/" + Subcategory.find(subcategory_id).name
  end


end
