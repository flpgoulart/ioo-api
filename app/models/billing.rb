class Billing < ApplicationRecord
  belongs_to :user

  validates_presence_of :document
  validates_presence_of :doc_date
  validates_presence_of :ref_ini_date
  validates_presence_of :ref_end_date
  validates_presence_of :link_document
  validates_presence_of :status 
  validates_presence_of :user_id 

end