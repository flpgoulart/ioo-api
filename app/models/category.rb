class Category < ApplicationRecord

    has_many :subcategories, dependent: :destroy
    has_many :personal_pages, dependent: :destroy

    validates_presence_of :name
    
end
