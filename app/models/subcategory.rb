class Subcategory < ApplicationRecord
  belongs_to :category

  has_many :products, dependent: :destroy

  validates_presence_of :name
  validates_presence_of :category_id
  
  def category_name
    Category.find(category_id).name
  end

end
