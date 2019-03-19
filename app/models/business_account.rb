class BusinessAccount < ApplicationRecord
  belongs_to :user

  validates_presence_of :name
  validates_presence_of :user_id 
  validates_presence_of :cnpj 
  validates_presence_of :city_name 
  validates_presence_of :uf 
  validates_presence_of :ddd_mobile 
  validates_presence_of :mobile 
  validates_presence_of :address_name 
  validates_presence_of :cep 
  #validates_presence_of :plan 
  validates_presence_of :status 

end



