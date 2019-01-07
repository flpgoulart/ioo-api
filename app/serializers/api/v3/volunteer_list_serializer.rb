class Api::V3::VolunteerListSerializer < ActiveModel::Serializer
  attributes :id, :volunteer_id, :improvement_id, :attendance, :rate_volunteer, :rate_improvement, :rate_social_entity, :created_at, :updated_at

  belongs_to :volunteer
  belongs_to :improvement
  
end
