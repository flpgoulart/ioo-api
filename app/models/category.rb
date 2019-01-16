class Category < ApplicationRecord

    has_many :subcategories, dependent: :destroy

    validates_presence_of :name
    
end
