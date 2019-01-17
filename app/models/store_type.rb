class StoreType < ApplicationRecord

    has_many :stores, dependent: :destroy
    
    validates_presence_of :name
    
end
