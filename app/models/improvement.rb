class Improvement < ApplicationRecord
  belongs_to :social_entity

  has_many :volunteer_lists, dependent: :destroy

  validates_presence_of :title, :short_description, :address, :limit_volunteers, 
                        :start_date, :end_date, :status, :social_entity_id, :people_benefited

end
