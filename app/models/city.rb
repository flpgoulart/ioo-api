class City < ApplicationRecord

    validates_presence_of :name
    validates_presence_of :uf
    validates_presence_of :cep_begin
    validates_presence_of :cep_end
    
end
