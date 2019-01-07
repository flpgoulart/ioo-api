class VolunteerList < ApplicationRecord
  belongs_to :volunteer
  belongs_to :improvement

  validates_presence_of :volunteer_id
  validates_presence_of :improvement_id

  validates_uniqueness_of :volunteer_id, scope: :improvement_id 

end
